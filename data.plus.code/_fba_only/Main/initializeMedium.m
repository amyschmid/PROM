function [mediumCompounds mediumAmounts uptakeRates] = initializeMedium()
    MAXIMUM_MEDIUM_VALUE = 1000000;
    MAXIMUM_UPTAKE_RATE = 1000;

    % *********************** Create the medium list
    % ***********************
    mediumCompounds = [
        'ER00023   '	%Exchange: (L-Tyrosine)
        'ER00024   '	%Free: (H2O)
        'ER00025   '	%Free: (H+)
        'ER00020   '	%Exchange: (L-Asparagine)
        'ER00021   '	%Exchange: (L-Isoleucine)
        'ER00022   '	%Exchange: (Iron)
        'ER00027   '	%Free: (CO2)
        'ER00028   '	%Free: (Oxygen)
        'ER00014   '	%Exchange: (L-Csyteine)
        'ER00015   '	%Exchange: (L-Proline)
        'ER00012   '	%Exchange: (L-Glutamine)
        'ER00013   '	%Exchange: (L-Glutamate)
        'ER00010   '	%Exchange: (L-Alanine)
        'ER00011   '	%Exchange: (L-Serine)
        'ER00018   '	%Exchange: (Orthophosphate)
        'ER00019   '	%Exchange: (Nitrate)
        'ER00016   '	%Exchange: (L-Threonine)
        'ER00017   '	%Exchange: (L-Aspartate)
        'ER00000   '	%Exchange (L-Tryptophan)
        'ER00001   '	%Exchange: (Sulfate)
        'ER00002   '	%Exchange: (Glycine)
        'ER00003   '	%Exchange: (L-Histidine)
        'ER00004   '	%Exchange: (L-Arginine)
        'ER00005   '	%Exchange: (L-Valine)
        'ER00006   '	%Exchange: (L-Leucine)
        'ER00007   '	%Exchange: (L-Methionine)
        'ER00008   '	%Exchange: (Phenylalanine)
        'ER00009   '	%Exchange: (L-Lysine)
        'ER00086   '	%Exchange: (NH3)
        'ER00095   '	%Exchange: (Na+)
        'ER00093   '	%Exchange: (Biotin)
        'ER00083   '	%Exchange: (Cobalt)
        'ER00096   '	%Exchange: (K+)
        'ER00048   '	%Exchange: (Folate)
        'ER00049   '	%Exchange: (Thiamin)
        'ER00054   '	%Free: (Hydrogen)
        'ER00058   '	%Sink: (Glycoaldehyde)
        'ER00059   '	%Exchange: (Cobalamide Coenzyme)
        'ER00119   '	%Exchange: (Cl-)
        'ER00110   '	%Exchange: ((S)-Lactate)
        'ER00112   '	%Exchange: (Glucose)
        'ER00111   '	%Exchange: (Photon)
        'ER00126   '	%Exchange: (Succinate)
        'ER00121   '	%Exchange: (Acetate)
        'ER00122   '	%Exchange: (D-Galactose)
        'ER00125   '	%Sink: (Cell)
        'ER00124   '	%Exchange: (Ornithine)
        'ER00135   '	%Exchange: (Hexadecanoic Acid)
        'ER00134   '	%Exchange: (Methanethiol)
        'ER00100   '	%Exchange: (Adenosine)
        'ER00101   '	%Exchange: (Thymidine)
        'ER00102   '	%Exchange: (Cytidine)
        'ER00103   '	%Exchange: (Guanosine)
        'ER00108   '	%Exchange: (D-Ribose)
        'ER00109   '	%Exchange: (sn-Glycerol-3P)
        'ER00104   '	%Exchange: (Deoxyadenosine)
        'ER00105   '	%Exchange: (Deoxyuridine)
        'ER00106   '	%Exchange: (Deoxycytidine)
        'ER00107   '	%Exchange: (Deoxyguanosine)
    ];


    % *********************** Initialize medium concentrations ***********************
    [m n] = size(mediumCompounds);
    mediumAmounts = zeros(m, 1);
    
    % Amino acids
    % Alanine
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00010')) = 3.530119563;
    
    % Cysteine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00014')) = 0.0;
    
    % Aspartate	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00017')) = 3.100573997;
    
    % Glutamate	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00013')) = 9.378891511;
    
    % Phenylalanine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00008')) = 0.454272746;
    
    % Glycine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00002')) = 1.685038032;
    
    % Histidine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00003')) = 0.0;
    
    % Isoleucine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00021')) = 2.937661096;
    
    % Lysine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00009')) = 1.437416506;
    
    % Leucine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00006')) = 5.216953608;
    
    % Methionine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00007')) = 1.228137567;
    
    % Asparagine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00020')) = 0.0;
    
    % Proline	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00015')) = 1.511644369;
    
    % Glutamine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00012')) = 0.0;
    
    % Arginine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00004')) = 0.39;
    
    % Serine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00011')) = 6.141136127;
    
    % Threonine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00016')) = 4.321706508;
    
    % Valine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00005')) = 0.817051096;
    
    % Tryptophan	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00000')) = 0.0;
    
    % Tyrosine	
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00023')) = 0.80128956;

    % Other nutrients
    % Na+
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00095')) = MAXIMUM_MEDIUM_VALUE;
    
    % Cl-        
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00119')) = MAXIMUM_MEDIUM_VALUE;
    
    % K+
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00096')) = MAXIMUM_MEDIUM_VALUE;
    
    % Nitrate
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00019')) = MAXIMUM_MEDIUM_VALUE;
    
    % Sulfate
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00001')) = MAXIMUM_MEDIUM_VALUE;
    
    % Orthophosphate
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00018')) = MAXIMUM_MEDIUM_VALUE;
    
    % Iron
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00022')) = MAXIMUM_MEDIUM_VALUE;
    
    % Cobalt
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00083')) = MAXIMUM_MEDIUM_VALUE;
    
    % Thiamin
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00049')) = MAXIMUM_MEDIUM_VALUE;
    
    % Biotin
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00093')) = MAXIMUM_MEDIUM_VALUE;
    
    % Folate       
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00048')) = MAXIMUM_MEDIUM_VALUE;
    
    % Ubiquitous nutrients    
    % H+
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00025')) = MAXIMUM_MEDIUM_VALUE;
    
    % Oxygen
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00028')) = MAXIMUM_MEDIUM_VALUE;
    
    % H2O                
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00024')) = MAXIMUM_MEDIUM_VALUE;
    
    % Hydrogen   
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00054')) = MAXIMUM_MEDIUM_VALUE;
    
    % CO2
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00027')) = MAXIMUM_MEDIUM_VALUE;
    
    % Ornithine
    mediumAmounts(listIndexOfString(mediumCompounds, 'ER00124')) = 0.9;    
    
    
    % *********************** Initialize uptake rates ***********************
    %Uptake rates in nmol/microL klett h
    [m n] = size(mediumCompounds);
    uptakeRates = zeros(m, 1);
    
    % Amino acids
    % Alanine
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00010')) = 0.00040334;
    
    % Cysteine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00014')) = 0.0;
    
    % Aspartate	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00017')) = 0.002707099;
    
    % Glutamate	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00013')) = 0.001106178;
    
    % Phenylalanine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00008')) = 0.000234646;
    
    % Glycine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00002')) = 0.000288303;
    
    % Histidine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00003')) = 0.0;
    
    % Isoleucine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00021')) = 0.001396843;
    
    % Lysine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00009')) = 0.000300564;
    
    % Leucine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00006')) = 0.001919857;
    
    % Methionine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00007')) = 0.000321224;
    
    % Asparagine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00020')) = 0.0;
    
    % Proline	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00015')) = 0.000495384;
    
    % Glutamine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00012')) = 0.0;
    
    % Arginine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00004')) = 0.1;
    
    % Serine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00011')) = 0.000995098;
    
    % Threonine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00016')) = 0.000838684;
    
    % Valine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00005')) = 0.00023015; 
    
    % Tryptophan	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00000')) = 0.0;
    
    % Tyrosine	
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00023')) = 0.000148588;

    % Other nutrients
    % Na+
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00095')) = MAXIMUM_UPTAKE_RATE;
    
    % Cl-        
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00119')) = MAXIMUM_UPTAKE_RATE;
    
    % K+
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00096')) = MAXIMUM_UPTAKE_RATE;
    
    % Nitrate
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00019')) = MAXIMUM_UPTAKE_RATE;
    
    % Sulfate
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00001')) = MAXIMUM_UPTAKE_RATE;
    
    % Orthophosphate
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00018')) = MAXIMUM_UPTAKE_RATE;
    
    % Iron
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00022')) = MAXIMUM_UPTAKE_RATE;
    
    % Cobalt
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00083')) = MAXIMUM_UPTAKE_RATE;
    
    % Thiamin
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00049')) = MAXIMUM_UPTAKE_RATE;
    
    % Biotin
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00093')) = MAXIMUM_UPTAKE_RATE;
    
    % Folate       
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00048')) = MAXIMUM_UPTAKE_RATE;
    
    % Ubiquitous nutrients    
    % H+
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00025')) = MAXIMUM_UPTAKE_RATE;
    
    % Oxygen
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00028')) = MAXIMUM_UPTAKE_RATE;
    
    % H2O                
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00024')) = MAXIMUM_UPTAKE_RATE;
    
    % Hydrogen   
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00054')) = MAXIMUM_UPTAKE_RATE;    
    
    % CO2
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00027')) = MAXIMUM_UPTAKE_RATE;   

    % Ornithine
    uptakeRates(listIndexOfString(mediumCompounds, 'ER00124')) = MAXIMUM_UPTAKE_RATE;         
end