function [sampleStructOut, mixedFrac] = gpSampler(sampleStruct, nPoints, bias, maxTime, maxSteps, threads, nPointsCheck)
%gpSampler Samples an arbitrary linearly constrained space using a fixed
%number of points that are moved in parallel
%
% [sampleStructOut, mixedFraction] = gpSampler(sampleStruct, nPoints, bias, maxTime, maxSteps)
%
% The space is defined by
%   A x <=,==,>= b
%   lb <= x <= ub
%
%INPUTS
% sampleStruct      Structure describing the space to be sampled and
%                   previous point sets
%   A               LHS matrix (optionally, if not A script checks for S)
%   b               RHS vector
%   lb              Lower bound
%   ub              Upper bound
%   csense          Constraint type for each row in A ('G', 'L', 'E')
%   warmupPoints 	Set of warmup points (optional, generated by default)
% 	points          Currently sampled points (optional)
%
%OPTIONAL INPUTS
% nPoints           Number of points used in sampling 
%                   (default = 2*nRxns or 5000 whichever is greater)
% bias
%   method          Biasing distribution: 'uniform', 'normal'
%   index           The reaction indexes which to bias (nBias total)
%   param           nBias x 2 matrix of parameters (for uniform it's min 
%                   max, for normal it's mu, sigma).
% maxTime           Maximum time alloted for the sampling in seconds
%                   (default 600 s, pass an empty number [] to set maxSteps instead)
% maxSteps          Maximum number of steps to take (default 1e10). Sampler
%                   will run until either maxStep or maxTime is reached.  
%                   Set maxStep or maxTime to 0 and no sampling will occur 
%                   (only warmup points generated).  
% threads           number of threads the sampler will use.  If you have a
%                   dual core machine, you can set it to 2 etc.  The speed
%                   up is almost linear w/ the number of cores.
%                   If using this feature and 2009a or newer, a futher 
%                   speedup can be obtained by starting matlab from the 
%                   command line by "typing matlab -singleCompThread"
%                   New feature:  if threads < 0, use distributed toolbox.
% nPointsCheck      Checks that minimum number of points (2*nRxns) are
%                   used. (Default = true).
%
%OUTPUT
% sampleStructOut   The sampling structure with some extra fields.
% mixedFract        The fraction mixed (relative to the warmupPts).  A value of 1
%                   means not mixed at all.  A value of .5 means completely mixed.  

%% Parameter Processing / error checking
sampleStructOut = 0; % in case of returning early
mixedFrac = 1; % in case of returning early
if nargin < 2
    nPoints = 5000;
end
if nargin < 3
    bias = [];
end
if ~isempty(bias)
    if ~isfield (bias, 'method')
        display('bias does not have a method set');
        return;
    end
end
if nargin < 4 || (isempty(maxTime) && isempty(maxSteps))
    maxTime = 10*60; % 10 minutes
end
if (nargin < 5) || isempty(maxSteps)
    % Max time takes precedence
    maxSteps = 1e10;
else
    % Set max steps instead of max time
    if (isempty(maxTime))
        maxTime = 1e10;
    end
end

if nargin < 6 || isempty(threads)
    threads = 1;
end

if nargin < 7, nPointsCheck = true; end

% Sanity checking
if (~ isfield (sampleStruct, 'A'))
    if isfield(sampleStruct, 'S')
        display('A set to S');
        sampleStruct.A = sampleStruct.S;
    else
        display('A and/or S not set');
        return;
    end
end
if (~ isfield (sampleStruct, 'b'))
    sampleStruct.b = zeros(size(sampleStruct.A,1), 1);
    display('Warning:  b not set.  Defaulting to zeros');
end
if (~ isfield (sampleStruct, 'csense'))
    sampleStruct.csense(1:size(sampleStruct.A,1)) = 'E';
    display('Warning:  csense not set.  Defaulting to all Equality constraints');
end
if (~isfield (sampleStruct, 'lb'))
    display('lb not set');
    return;
end
if (~isfield (sampleStruct, 'ub'))
    display('ub not set');
    return;
end

%% internal data generation
% make internal structure
[A, b, csense, lb, ub] = deal(sampleStruct.A, sampleStruct.b, sampleStruct.csense, sampleStruct.lb, sampleStruct.ub);

% constInd = (lb == ub);
% constVal = lb(constInd);
% Aconst = A(:,constInd);
% b = b - Aconst*constVal;
% A = A(:,~constInd);
% lb = lb(~constInd);
% ub = ub(~constInd);
% [sampleStruct.A, sampleStruct.b, sampleStruct.csense, sampleStruct.lb, sampleStruct.ub] = deal(A, b, csense, lb, ub);

[rA, dimx] = size(A);
if (~ isfield(sampleStruct, 'internal'))
    Anew = sparse(0, dimx);
    Cnew = sparse(0, dimx);
    Bnew = zeros(rA, 1);
    Dnew = zeros(rA, 1);
    rAnew = 0;
    rCnew = 0 ;
    for i = 1:size(A, 1)
        switch csense(i)
            case 'E'
                rAnew = rAnew+1;
                Anew(rAnew,:) = A(i,:);
                Bnew(rAnew,:) = b(i);

            case 'G'
                rCnew=rCnew+1;
                Cnew(rCnew,:) = -A(i,:);
                Dnew(rCnew,:) = -b(i);
            case 'L'
                rCnew=rCnew+1;
                Cnew(rCnew,:) = A(i,:);
                Dnew(rCnew,:) = b(i);
            otherwise
                display ('whoops.  csense can only contain E, G, or L')
                return;
        end
    end
    
    %Anew = Anew(1:rAnew,:);
    Bnew = Bnew(1:rAnew,:);
    Dnew = Dnew(1:rCnew,:);

    % calculate offset
    if find(Bnew ~= 0)
        offset = Anew\Bnew;
    else
        offset = zeros(size(Anew,2), 1);
    end

    % rescale Bnew, Dnew
    Boffset = Bnew - Anew*offset;
    if (max(abs(Boffset)) > .0000000001)
        display('whoops.  It looks like the offset calculation made a mistake.  this should be zero.');
        max(abs(Boffset))
        return;
    end
    Doffset = Dnew - Cnew*offset;

    lbnew = lb - offset;
    ubnew = ub - offset;
    
    sampleStruct.internal.offset = offset;
    sampleStruct.internal.Anew = Anew;
    sampleStruct.internal.Cnew = Cnew;
    sampleStruct.internal.Dnew = Doffset;
    sampleStruct.internal.lbnew = lbnew;
    sampleStruct.internal.ubnew = ubnew;
    
    if (isfield(sampleStruct, 'warmupPts'))
        sampleStruct = rmfield(sampleStruct, 'warmupPts');
    end
    if ~isempty(bias)
        sampleStruct.internal.fixed = bias.index;
    else
        sampleStruct.internal.fixed = [];
    end
end

%% Generate warmup points
if (~ isfield(sampleStruct, 'warmupPts') )
    fprintf('Generating warmup points\n');
%     warmupPts = warmup(sampleStruct, nPoints, bias);
    warmupPts = createHRWarmup(sampleStruct, nPoints, false, bias, nPointsCheck);
    sampleStruct.warmupPts = warmupPts;
    if (isfield(sampleStruct, 'points'))
        sampleStruct = rmfield(sampleStruct, 'points');
    end
    if (isfield(sampleStruct, 'bias'))
        sampleStruct = rmfield(sampleStruct, 'bias');
    end
    sampleStruct.steps = 0;
    save sampleStructTmp sampleStruct
else
    fprintf('Warmup points already present.\n');
%    save sampleStructTmp sampleStruct
end

%% Do actual sampling
fprintf('Sampling\n');
if(maxTime > 0 && maxSteps > 0)
    if threads < 0  %uses distributed toolbox.
        sampleStruct = ACHRSamplerDistributedGeneral(sampleStruct, ceil(maxSteps/50), 50, maxTime);
    else
        sampleStruct = ACHRSamplerParallelGeneral(sampleStruct, ceil(maxSteps/50), 50, maxTime, threads);
    end
    mixedFrac = mixFraction(sampleStruct.points, sampleStruct.warmupPts, sampleStruct.internal.fixed);
else
    mixedFrac = 1;
end

sampleStructOut = sampleStruct;

return;



%% warmup Point generator
function warmupPts = warmup(sampleProblem, nPoints, bias)

dimX = size(sampleProblem.A, 2); 
warmupPts = zeros(dimX, nPoints);

[LPproblem.A,LPproblem.b,LPproblem.lb,LPproblem.ub,LPproblem.csense,LPproblem.osense] = ...
    deal(sampleProblem.A,sampleProblem.b,sampleProblem.lb,sampleProblem.ub,sampleProblem.csense,1);

% Generate the correct parameters for the biasing reactions
if ~isempty(bias)
    if (~ismember(bias.method,{'uniform','normal'}))
        error('Biasing method not implemented');
    end
    for k = 1:size(bias.index)
        ind = bias.index(k);
        % Find upper & lower bounds for bias rxns to ensure that no
        % problems arise with values out of bounds
        LPproblem.c = zeros(size(LPproblem.A,2),1);
        LPproblem.c(ind) = 1;
        LPproblem.osense = -1;
        sol = solveCobraLP(LPproblem);
        maxFlux = sol.obj;
        LPproblem.osense = 1;
        sol = solveCobraLP(LPproblem);
        minFlux = sol.obj;

        if strcmp(bias.method, 'uniform')
            upperBias = bias.param(k,2);
            lowerBias = bias.param(k,1);
            if (upperBias > maxFlux || upperBias < minFlux)
                upperBias = maxFlux;
                disp('Invalid bias bounds - using default bounds instead');
            end             
            if (lowerBias < minFlux || lowerBias > maxFlux)
                lowerBias = minFlux;
                disp('Invalid bias bounds - using default bounds instead');
            end
            bias.param(k,1) = lowerBias;
            bias.param(k,2) = upperBias;
        elseif strcmp(bias.method, 'normal')
            biasMean = bias.param(k,1);
            if (biasMean > maxFlux || biasMean < minFlux)
                 bias.param(k,1) = (minFlux + maxFlux)/2;
                disp('Invalid bias mean - using default mean instead');
            end
            biasFluxMin(k) = minFlux;
            biasFluxMax(k) = maxFlux;
        end
    end
end

%Generate the points
i = 1;
while i <= nPoints/2
    if mod(i,10) ==0
        fprintf('%d\n',2*i);
    end
    if ~isempty(bias)
        for k = 1:size(bias.index)
            ind = bias.index(k);
            if strcmp(bias.method, 'uniform')
                diff = bias.param(k,2) - bias.param(k,1);
                fluxVal = diff*rand() + bias.param(k,1);
            elseif strcmp(bias.method, 'normal')
                valOK = false;
                % Try until get points inside the space
                while (~valOK)
                    fluxVal = randn()*bias.param(k,2)+bias.param(k,1);
                    if (fluxVal <= biasFluxMax(k) && fluxVal >= biasFluxMin(k))
                        valOK = true;
                    end
                end
            end
            LPproblem.lb(ind) = 0.99999999*fluxVal;
            LPproblem.ub(ind) = 1.00000001*fluxVal;
        end
    end
    
    % Pick the next flux to optimize, cycles though each reaction
    % alternates minimization and maximization for each cycle

    
    
    LPproblem.c = rand(dimX, 1)-.5;
    validFlag = true;
    
    for maxMin = [1, -1]  
      % Set the objective function
      if i <= dimX
%        LPproblem.c = rand(dimX, 1)-.5;
        LPproblem.c(i) = 5000;
      end
      LPproblem.osense = maxMin;
      
      % Determine the max or min for the rxn
      sol = solveCobraLP(LPproblem);
      x = sol.full;
      if maxMin == 1
          sol1 = sol;
      else
          sol2 = sol;
      end
      status = sol.stat;
      if status ~= 1
          display ('invalid solution')
          validFlag = false;
          display(status)
          pause;
      end
        
      % Move points to within bounds
      x(x > LPproblem.ub) = LPproblem.ub(x > LPproblem.ub);
      x(x < LPproblem.lb) = LPproblem.lb(x < LPproblem.lb); 
      
      % Store point
      % For non-random points just store a min/max point
      
      if (maxMin == 1)
          warmupPts(:,2*i-1) = x;
      else 
          warmupPts(:,2*i) = x;
      end
    end
    
    if validFlag
        %postprocess(LPproblem, sol1, sol2)
        i = i+1;
    end
end
centerPoint = mean(warmupPts,2);

% Move points in
if isempty(bias)
    warmupPts = warmupPts*.33 + .67*centerPoint*ones(1,nPoints);
else
    warmupPts = warmupPts*.99 + .01*centerPoint*ones(1,nPoints);
end

% Permute point order
% if (permFlag)
%     [nRxns,nPoints] = size(warmupPts);
%     warmupPts = warmupPts(:,randperm(nPoints));
% end
return;

%% post processing for better warmup point generation.
% function out = postprocess(LPproblem, sol1, sol2)
% x1 = sol1.full;
% x2 = sol2.full;
% closetoboundary(LPproblem, x1)
% closetoboundary(LPproblem, x2)
% 
% separation = sol2.obj - sol1.obj;
% if separation < .00001
%     disp('low separation');
%     pause;
% end
% LPproblem.A = [LPproblem.A; LPproblem.c];
% LPproblem.b(end+1) = sol1.obj + separation*.1;
% Lpproblem.csense(end+1) = 'L';
% 
% 
% 
% pause;
% out = 2;
% 
% return;

% function counter = closetoboundary(LPproblem, sol)
% etol = 1e-5;
% counter = 0;
% counter = counter + sum(LPproblem.A((LPproblem.csense == 'G'),:)*sol - LPproblem.b(LPproblem.csense =='G') < etol)
% counter = counter + sum(LPproblem.b(LPproblem.csense =='L') - LPproblem.A((LPproblem.csense == 'L'),:)*sol < etol)
% counter = counter + sum(LPproblem.ub - sol < etol)
% counter = counter + sum(sol - LPproblem.lb < etol)
% return;


