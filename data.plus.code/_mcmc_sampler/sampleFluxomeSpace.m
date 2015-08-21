% __author__ Firas Said Midani, fsm3@duke.edu
% This script is a follow-up to "run_PROM_HaloS.m" 
% The goal is to sample the PROM-predicted metabolic reactions for
% probabiblty distribution of their fluxes 

% START-UP NOTES: begin in the primary directory and add all necessary
% % paths for CobraToolbox,MCMCstat,gurobi, and gurobiMex.

% clear;clc; 
% cd('/home/fmidani/Documents/SchmidDocuments/SchmidDocuments/haloS_PROM_V6') 
% addpath('/home/fmidani/Documents/routines/glpkmex')
% addpath('/home/fmidani/Documents/MATLAB/cobra'); initCobraToolbox;
% addpath('/home/fmidani/Documents/MATLAB/mcmcstat')
% addpath('/home/fmidani/Documents/routines/gurobi_mex_v1.61')
% addpath('/opt/gurobi562/linux64/matlab')
% addpath('/home/fmidani/Documents/routines/optGpSampler/Matlab')
% addpath('/home/fmidani/Documents/routines/optGpSampler/Matlab')

clear;clc; 
addpath('/Library/gurobi604/mac64/matlab');
addpath(genpath('./_dependencies/libSBML-5.11.4-matlab')); 
addpath(genpath('./_dependencies/SBMLToolbox-4.1.0/toolbox')); 
addpath('./_dependencies/Matlab-Toolbox-Cobra-Apr2014/cobra'); 
addpath('./_dependencies/MATLAB-Toolbox-mcmcstat');
addpath('./_dependencies/glpkmex-master/glpk.m');
initCobraToolbox;

% Load a paritcular model and its simulation results
simname='HaloS';
load('./_main_scripts/_output/PROM_HaloS_output.mat');

for tp=7
    
    cd(strcat('./_mcmc_sampler'))
    filename=(strcat('tp-',num2str(tp)));
    mkdir(filename); cd(filename);
    
    % Shared Model Parameters whether wildtype or a knockout strain
    S       = model.S;weights = model.c;
    lbg     = model.lb; ubg = model.ub;
    a1      = [S, zeros(size(S,1),length(ubg)) , zeros(size(S,1),length(ubg)) ]; %size 643x2340
    a2      = sparse([eye(length(ubg)), eye(length(ubg)),zeros(length(ubg))]);   %size 780x2340
    a3      = sparse([eye(length(ubg)), zeros(length(ubg)),-eye(length(ubg))]);  %size 780x2340
    A       = [a1;a2;a3]; % 1..643 (metabolites); 1..780 (lbs); 1..70 (ubs) times 1..2340 (optimal,lb,ub); total: size 2203x2340
    csense1 = [repmat('E',size(S,1),1);repmat('G',size(lbg,1),1);repmat('L',size(lbg,1),1)];

    % Define Model Parameters which are time-point and wildtype-specific 
    weights11 = [weights;zeros(2*length(lbg),1)];                                      %size 2340 (optimal,lb,ub)
    lb11      = [-1000*ones(length(lbg),1);zeros(length(lbg),1);zeros(length(lbg),1)]; %size 2340 lb of optimal
    ub11      = [1000*ones(length(lbg),1);zeros(length(lbg),1);zeros(length(lbg),1)];  %size 2340 ub of optimal
    dxdt0     = [zeros(size(S,1),1);lbg;ubg];                                          % size 2203 RHS: Sv=dxdt0 with original model.lb and model.ub as RHS elements
    ctype1    = [repmat('S',size(S,1),1);repmat('L',size(lbg,1),1);repmat('U',size(lbg,1),1)];

    % FBA of wildtype strain 
    [v0(:,tp),f0(tp),st] = glpk(-weights11,A,dxdt0,lb11,ub11,ctype1)
    
    %Sample fluxome for wildtype (delta:ura3) strain
    sampleStruct        = struct; 
    sampleStruct.S      = A; 
    sampleStruct.A      = A; 
    sampleStruct.b      = dxdt0; 
    sampleStruct.lb     = lb11; 
    sampleStruct.ub     = ub11; 
    sampleStruct.csense = csense1;
    [sampleStructOut,mixedFraction] = gpSampler(sampleStruct,5000);
    
    %save output
    save(strcat(filename,'_wt'),'sampleStructOut','mixedFraction');
    clear sampleStructOut mixedFraction;
    
    % Define Model Parameters which are time-point and delta_trmb-specific
    weights11 = weights_cell(:,tp);
    lb11      = lb_cell(:,tp);
    ub11      = ub_cell(:,tp);
    dxdt0     = dxdt0_cell(:,tp);
    ctype1    = [repmat('S',643,1);repmat('L',780,1);repmat('U',780,1)];

    %FBA of PROM-modified delta:trmb strain
    [v00(:,tp),f00(tp)] = glpk(-weights11,A,dxdt0,lb11,ub11,ctype1);
    
    %Sample fluxome for delta:trmb strain
    sampleStruct        = struct; 
    sampleStruct.S      = A; 
    sampleStruct.A      = A; 
    sampleStruct.b      = dxdt0; 
    sampleStruct.lb     = lb11; 
    sampleStruct.ub     = ub11; 
    sampleStruct.csense = csense1;
    [sampleStructOut,mixedFraction] = gpSampler(sampleStruct,5000);
    
    %save output
    save(strcat(filename,'_delta_trmb'),'sampleStructOut','mixedFraction');
    clear sampleStructOut mixedFraction;
    
    cd ../../..
    
end




