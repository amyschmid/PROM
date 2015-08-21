function [f placeIds transitionIds geneIds geneReactionTable rev] = load_haloS_network()
%load_haoS_network modified from loadNetwork() by Gonzalez et al. (2009) Mol. Biosyst. 4, 148?59 (2008).

% __author__  =  Firas Said Midani
% __e-mail__  =  fsm3@duke.edu
% ___date___  =  2015.03.28
    
    % Load the data from files
    display('Loading network information...');
    
    load -ascii './_model_definition/f.txt'
    [m n] = size(f);
    display(sprintf('Loaded f with dimensions: %d x %d', m, n));

    placeIds = loadStringArrayFromText('./_model_definition/placeIds.txt');    
    [m n] = size(placeIds);
    display(sprintf('Loaded placeIds with dimensions: %d x %d', m, n));
    
    transitionIds = loadStringArrayFromText('./_model_definition/transitionIds.txt');
    [m n] = size(transitionIds);
    display(sprintf('Loaded transitionIds with dimensions: %d x %d', m, n));
    
    geneIds = loadStringArrayFromText('./_model_definition/geneIds.txt');
    [m n] = size(geneIds);
    display(sprintf('Loaded geneIds with dimensions: %d x %d', m, n));
    
    load -ascii './_model_definition/geneReactionTable.txt'
    [m n] = size(geneReactionTable);
    display(sprintf('Loaded GeneReactionTable with dimensions: %d x %d', m, n));
 
    load -ascii './_model_definition/rxnReversibility.txt'; rev = rxnReversibility;
    [m n] = size(rev);
    display(sprintf('Loaded GeneReactionTable with dimensions: %d x %d', m, n));
    
    disp('Network information successfully loaded.');

end
