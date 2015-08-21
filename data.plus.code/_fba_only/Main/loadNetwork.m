function [Aeq f bounds placeIds transitionIds geneIds Gene_ReactionTable] = loadNetwork()

    Aeq = [];
    f = [];    
    bounds = [];    
    Gene_ReactionTable = [];
    
    % Load the data from files
    disp('Loading network information...');
    
    load -ascii './_model_definition/Aeq.txt'
    [m n] = size(Aeq);
    display(sprintf('Loaded Aeq with dimensions: %d x %d', m, n));    
    
    load -ascii './_model_definition/f.txt'
    [m n] = size(f);
    display(sprintf('Loaded f with dimensions: %d x %d', m, n));

    load -ascii './_model_definition/bounds.txt'
    [m n] = size(bounds);
    display(sprintf('Loaded bounds with dimensions: %d x %d', m, n));

    placeIds = loadStringArrayFromText('./_model_definition/placeIds.txt');    
    [m n] = size(placeIds);
    display(sprintf('Loaded placeIds with dimensions: %d x %d', m, n));
    
    transitionIds = loadStringArrayFromText('./_model_definition/transitionIds.txt');
    [m n] = size(transitionIds);
    display(sprintf('Loaded transitionIds with dimensions: %d x %d', m, n));
    
    geneIds = loadStringArrayFromText('./_model_definition/geneIds.txt');
    [m n] = size(geneIds);
    display(sprintf('Loaded geneIds with dimensions: %d x %d', m, n));
    
    load -ascii './_model_definition/Gene_ReactionTable.txt'
    [m n] = size(Gene_ReactionTable);
    display(sprintf('Loaded Gene_ReactionTable with dimensions: %d x %d', m, n));
    
    disp('Network information successfully loaded.');

end
