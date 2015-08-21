% __author__ =  Firas Said Midani
% __e-mail__ =  fsm3@duke.edu
% ___date___ =  2015.03.28

% START-UP NOTES
% (1) begin in the primary directory 
% (2) make sure 'glpk' is installed in your system and its path added to Matlab
clear;clc; 
run('./_dependencies/halos_startup.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the metabolic model of Halobacterium salinarium and run PROM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./_main_scripts');
addpath('./_aux_scripts');
addpath('./_fba_only/Main/tools');
[f,placeIds,transitionIds,genes,rxnGeneMat,rev] = load_halos_network();
c=f;mets=placeIds;rxns=transitionIds; rxnGeneMat=rxnGeneMat;
clear f placeIds transitionIds;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize model parameters not defined by Gonzalez et al. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

charges=zeros(size(mets,1),1,'int32');
rules=cell(size(rxns,1),1);
grRules=cell(size(rxns,1),1);
subSystems=cell(size(rxns,1),1);
rxnNames=cell(size(rxns,1),1);
metNames=cell(size(mets,1),1);
metFormulas=cell(size(mets,1),1);
b=zeros(size(mets,1),1);
description='haloS_FBA_PROM_hybrid';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure compatibility of Gonzalez et al. metabolic model with PROM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model.rxns=cellstr(rxns);%reaction Ids
model.mets=cellstr(mets);%metabolite Ids 
model.rev=rev;%reversibility of reactions
model.c=c';%objective function 
model.charges=charges;%ignore
model.rules=cellstr(repmat(cellstr(''), size(rxns,1),1));%ignore
model.genes=cellstr(genes);%gene Ids
model.rxnGeneMat=sparse(rxnGeneMat);%Reactions downstream of genes    
model.subSystems=cellstr(repmat(cellstr(''), size(rxns,1),1));%ignore
model.rxnNames=cellstr(repmat(cellstr(''), size(rxns,1),1));%ignore
model.metNames=cellstr(repmat(cellstr(''), size(mets,1),1));%ignore
model.metFormulas=cellstr(repmat(cellstr(''), size(mets,1),1));%ignore
model.b=b;%linear constraints RHS
model.description='haloS_FBA_PROM_hybrid';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encode model.rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:size(model.rxnGeneMat,1) %parse by rxn
          genesInc=find(model.rxnGeneMat(i,:)); %find genes involved
    if    isempty(genesInc) %if none, no rule needed
          model.rules{i}=''; 
    else  % formulate rule
          toRecord=strcat('(');
          for j=1:length(genesInc)-1 % add every gene
            toRecord=strcat(toRecord,' x(',num2str(genesInc(j)),') |',' ');
          end
          toRecord=strcat(toRecord,' x(',num2str(genesInc(length(genesInc))),') )');
          model.rules{i}=toRecord;
    end
    clear rxnsInc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extract the 2400 genes expression data for 361 conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varnames     = loadStringArrayFromText('./_microarray_data/varnames.txt');
expressionid = loadStringArrayFromText('./_microarray_data/casenames.txt');
expression   = dlmread('./_microarray_data/data.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the TrmB targets 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s       = tdfread('./_regulator_network/chipData_113_TFs.csv','\t'); 
targets = cellstr(s.TARGETS);
targets = targets(ismember(targets,model.genes));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the protein(trmB)-* (regulator-target)relationships
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

regulator    = repmat({'VNG1451C'},size(targets,1),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keep blank if no literature evidence or prior probabilities will be
% included in PROM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
litevidence = [];prob_prior = []; 

clearvars -except ctr model expression expressionid regulator targets ...
                  litevidence prob_prior microA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iiterate over the 29 time-points of the Gonzalez et al. expeirmental
% measurements and perform FBA/PROM at each interval. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_all=[];v_all=[];
f0_all=[];v0_all=[];

for ctr=1:53

fprintf(strcat('\nRunnign PROM for time point: ','#',num2str(ctr),'\n'));
clearvars -except microA f_all f0_all v_all v0_all weights_cell   ... 
                  dxdt0_cell lb_cell ub_cell ctr model expression ...
                  expressionid regulator targets litevidence prob_prior;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each interval is distinct by the stoichiometry (S), and flux bounds (lb
% and ub). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model.S =dlmread(strcat('./_fba_only/Main/_main_output/Aeq/Aeq-',num2str(ctr),'.txt'));
model.lb=dlmread(strcat('./_fba_only/Main/_main_output/lb/lb-',num2str(ctr),'.txt'));
model.ub=dlmread(strcat('./_fba_only/Main/_main_output/ub/ub-',num2str(ctr),'.txt'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run prom_haloS, a PROM variant which accomodates haloS model definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[f,v,f0,v0,status1,lostxns,model_parameters] =  run_PROM_func(model,expression,expressionid,regulator,targets,litevidence,prob_prior);

f0_all(:,ctr) = f0;     v0_all(:,ctr) = v0;
f_all(:,ctr)  = f;      v_all(:,ctr)  = v'; 

weights_cell(:,ctr) = model_parameters{1};
dxdt0_cell(:,ctr)   = model_parameters{2};
lb_cell(:,ctr)      = model_parameters{3};
ub_cell(:,ctr)      = model_parameters{4};

end

save(strcat('./_main_scripts/_output/PROM_HaloS_output.mat'));