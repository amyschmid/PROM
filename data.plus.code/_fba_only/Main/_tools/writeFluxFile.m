function writeFluxFile(filename, transitionList, fluxes)
    file_id = fopen(filename, 'w');
    
    if (file_id > -1)
        [m n] = size(transitionList);

        fprintf(file_id, 'id\tflux\n');
        for i = 1 : m
            fprintf(file_id, '%s', transitionList(i, :));
            fprintf(file_id, '\t');
            fprintf(file_id, '%d', fluxes(i));
            fprintf(file_id, '\n');
        end

        fclose(file_id);
    else
        disp('Error writing flux file');
    end

end
