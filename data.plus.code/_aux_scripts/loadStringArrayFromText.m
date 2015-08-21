function stringArray = loadStringArrayFromText(filename)
%loadStringArrayFromText sourced from 
% Gonzalez et al. (2009) Mol. Biosyst. 4, 148?59 (2008).       

    [fid message] = fopen(filename);        
    if fid < 0
        disp(message);
        error(message);
    end
    
    % Get line lengths
    tline = fgetl(fid);       
    stringArray = char(tline);
    fclose(fid);
    
    
    fid = fopen(filename);
    ctr = 0;
    while 1
        tline = fgetl(fid);                
        if ~ischar(tline)
            break              
        end
        ctr = ctr + 1;
        stringArray(ctr, :) = char(tline);
    end
    fclose(fid);
    
end
