function index = listIndexOfString(list, str)
    index = -1;
    
    [m n] = size(list);
    
    for i = 1 : m
        if (strcmp(deblank(list(i,:)), deblank(str)) == 1)
           index = i;
           break;
        end
    end    

end
