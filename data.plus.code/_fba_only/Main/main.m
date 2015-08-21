function main

    addpath('./_tools');
    
    % ********** Constants and settings **********
    CELLS_PER_OD_ML = 1.2e+9;
    AVOGADROS_NUMBER = 6.02E+23;
    CONTAINER_VOLUME_MICROL = 30000;
    MEASUREMENT_VOLUME_MICROL = 0.5;
    ATP_ATTO_MOL_PER_HOUR_KLETT_ML = 43699857509;
    
    START_TIME = 36.78;
    END_TIME = 143; %END_TIME = 95; 
    DELTA_TIME = 2.02;
    INITIAL_KLETT = 2.0;

    % ********** Initialize experimental data values **********
    klett_time_data = [37.35070766	37.36070766	37.37070766	37.38070766	58.50564359	61.15038159	 ...
                       64.5975788	67.63474173	67.64474173	73.80994972	75.431718	77.01449614	 ...
                       77.7943499	82.37651033	90.02681584	93.23969137	93.24969137	97.50657916	 ...
                       103.2000723	107.5240449	111.1711068	112.4855937	118.4009722	123.7937456	 ...
                       125.849104	136.0752784	139.3699685	139.3799685	143.1193507];    
                   
    klett_data      = [2	2	2	2	10	12	15	18	18	25	27	30	30	36	46	50	50	55	 ...
                       61	65	68	69	73	76	77	81	82	82	83];
    
    measurements_list = ['ER00010   '; 'ER00014   '; 'ER00017   '; 'ER00013   '; 'ER00008   ';   ...
                         'ER00002   '; 'ER00003   '; 'ER00021   '; 'ER00009   '; 'ER00006   ';   ...
                         'ER00007   '; 'ER00020   '; 'ER00015   '; 'ER00012   '; 'ER00004   ';   ...
                         'ER00011   '; 'ER00016   '; 'ER00005   '; 'ER00000   '; 'ER00023   '];
            
    measurements_time_data = [35	39	40	43	47.5	50	66	66.1	71	71.1	75.5	75.6 ...
                              80	80.1	90	90.1	95	95.1	101	101.1	105	105.1	120	 ...
                              120.1	124	124.1	145	145.1	160.5	160.6	173	173.1	203	203.1];    
    measurements = [
        3.4675000e+000  3.6804000e+000  3.5040000e+000  3.2400000e+000  3.4500000e+000  3.6365000e+000  3.3255000e+000 -1.0000000e+000  3.6450000e+000  3.3900000e+000  3.1315000e+000  3.2985000e+000  3.4600000e+000  3.1450000e+000  3.0410000e+000  3.0915000e+000  3.3750000e+000  3.1150000e+000  3.2055000e+000  3.4435000e+000  3.4250000e+000  3.2250000e+000  3.1800000e+000  3.1535000e+000  3.2305000e+000  3.8530000e+000  3.1850000e+000  3.1150000e+000  3.2255000e+000  4.0650000e+000  3.5700000e+000  2.9800000e+000  3.3250000e+000  3.3850000e+000
        0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        3.0120000e+000  3.1320000e+000  3.2940000e+000  3.0450000e+000  3.1150000e+000  2.5775000e+000  2.6130000e+000  2.6150000e+000  2.8000000e+000  2.7100000e+000  2.1425000e+000  1.4220000e+000  2.3850000e+000  2.2650000e+000  1.7165000e+000  7.2050000e-001  1.5650000e+000  1.6100000e+000  1.1370000e+000  0.0000000e+000  1.1050000e+000  1.1350000e+000  1.8250000e-001  2.9500000e-001  5.0900000e-001  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        9.6200000e+000  1.0092000e+001  9.9000000e+000  8.8250000e+000  9.1450000e+000  9.7300000e+000  9.2850000e+000 -1.0000000e+000  9.4750000e+000  8.9900000e+000  8.7400000e+000  9.1200000e+000  9.0700000e+000  8.6750000e+000  8.5000000e+000  8.3200000e+000  9.1250000e+000  8.7550000e+000  8.8700000e+000  8.9450000e+000  9.0550000e+000  8.8900000e+000  8.6300000e+000  8.5200000e+000  8.6700000e+000  8.6650000e+000  7.9300000e+000  8.0400000e+000  8.0950000e+000  8.7700000e+000  8.0500000e+000  6.9700000e+000  7.0100000e+000  6.9700000e+000
        4.6210000e-001  4.7904000e-001  4.9800000e-001  4.7000000e-001  4.5500000e-001  4.1655000e-001  4.2460000e-001  4.8495000e-001  4.9000000e-001  4.0700000e-001  3.4260000e-001  3.2905000e-001  3.9000000e-001  3.5000000e-001  3.2245000e-001  2.5015000e-001  3.3500000e-001  3.2500000e-001  3.1740000e-001  2.3135000e-001  3.0850000e-001  3.1500000e-001  2.5000000e-001  2.4500000e-001  2.5760000e-001  1.6795000e-001  1.9500000e-001  2.2500000e-001  1.7210000e-001  1.3575000e-001  1.7000000e-001  1.4000000e-001  0.0000000e+000  1.2500000e-001
        1.6790000e+000  1.7784000e+000  1.7100000e+000  1.5700000e+000  1.7050000e+000  1.7845000e+000  1.6070000e+000 -1.0000000e+000  1.7900000e+000  1.6650000e+000  1.5340000e+000  1.5740000e+000  1.6650000e+000  1.5400000e+000  1.5065000e+000  1.4450000e+000  1.6300000e+000  1.5200000e+000  1.5000000e+000  1.4970000e+000  1.6200000e+000  1.5350000e+000  1.4600000e+000  1.4350000e+000  1.4585000e+000  1.5510000e+000  1.4000000e+000  1.3700000e+000  1.3735000e+000  1.6100000e+000  1.4900000e+000  1.3500000e+000  1.3700000e+000  1.4850000e+000
        0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        3.0105000e+000  3.1464000e+000  3.1380000e+000  2.8800000e+000  2.9550000e+000  2.8335000e+000  2.6820000e+000  3.1245000e+000  2.9250000e+000  2.7700000e+000  2.3750000e+000  2.1515000e+000  2.6200000e+000  2.4700000e+000  2.1645000e+000  1.7660000e+000  2.3000000e+000  2.2500000e+000  1.9905000e+000  1.5540000e+000  2.1800000e+000  2.1350000e+000  1.7550000e+000  1.8150000e+000  1.7120000e+000  1.1085000e+000  1.3500000e+000  1.3950000e+000  1.2960000e+000  1.0495000e+000  1.0600000e+000  9.6000000e-001  6.7500000e-001  7.7500000e-001
        1.5080000e+000  1.5588000e+000  1.4700000e+000  1.3700000e+000  1.3550000e+000  1.5145000e+000  1.4245000e+000 -1.0000000e+000  1.4350000e+000  1.3050000e+000  1.3085000e+000  1.3595000e+000  1.3150000e+000  1.2850000e+000  1.2620000e+000  1.1945000e+000  1.2550000e+000  1.2400000e+000  1.3230000e+000  1.2760000e+000  1.2550000e+000  1.2450000e+000  1.1650000e+000  1.2100000e+000  1.2675000e+000  1.2545000e+000  1.0650000e+000  1.0700000e+000  1.1355000e+000  1.3150000e+000  1.0550000e+000  9.2000000e-001  9.9000000e-001  1.0000000e+000
        5.2400000e+000  5.5530000e+000  5.6466000e+000  5.0170000e+000  5.2600000e+000  5.1350000e+000  4.8155000e+000  5.6750000e+000  5.3250000e+000  5.0900000e+000  4.3905000e+000  4.1615000e+000  4.9350000e+000  4.6550000e+000  4.1025000e+000  3.4980000e+000  4.5450000e+000  4.4150000e+000  3.8880000e+000  3.3065000e+000  4.3850000e+000  4.3150000e+000  3.7550000e+000  3.8400000e+000  3.4765000e+000  2.7640000e+000  3.1750000e+000  3.1850000e+000  2.8620000e+000  2.6960000e+000  2.8050000e+000  2.4600000e+000  2.0750000e+000  2.3000000e+000
        1.1940000e+000  1.1832000e+000  1.2720000e+000  1.1600000e+000  1.2150000e+000  1.1460000e+000  1.0655000e+000  1.3225000e+000  1.3050000e+000  1.2300000e+000  1.0090000e+000  1.0410000e+000  1.2350000e+000  1.1450000e+000  9.8450000e-001  8.1450000e-001  1.2300000e+000  1.1515000e+000  9.0050000e-001  7.9800000e-001  1.0550000e+000  1.0250000e+000  9.2000000e-001  9.1500000e-001  8.0250000e-001  7.0550000e-001  8.0000000e-001  7.9000000e-001  6.9750000e-001  7.2650000e-001  6.8000000e-001  5.9000000e-001  5.0000000e-001  5.4500000e-001
        0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        1.6070000e+000  1.4874000e+000  1.8240000e+000  1.2550000e+000  1.3700000e+000  1.4415000e+000  1.6150000e+000  1.8020000e+000  1.4050000e+000  1.4150000e+000  9.6050000e-001  1.2360000e+000  1.2700000e+000  1.3250000e+000  1.1765000e+000  1.0035000e+000  1.1600000e+000  1.1015000e+000  1.2450000e+000  1.2010000e+000  1.1350000e+000  1.2100000e+000  9.7000000e-001  1.0000000e+000  1.0265000e+000  1.0295000e+000  8.6500000e-001  6.0000000e-001  9.5400000e-001  9.4950000e-001  7.7000000e-001  8.6500000e-001  5.9000000e-001  7.8000000e-001
        0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        4.0000000e-001 -1.2000000e+000 -1.2000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        6.0100000e+000  6.4860000e+000  6.2400000e+000  5.7050000e+000  5.9750000e+000  6.1450000e+000  5.8050000e+000 -1.0000000e+000  6.2000000e+000  5.5850000e+000  5.4650000e+000  5.6400000e+000  6.0000000e+000  5.5900000e+000  5.4250000e+000  5.1100000e+000  5.7700000e+000  5.5950000e+000  5.4100000e+000  5.1150000e+000  5.8150000e+000  5.6300000e+000  5.2700000e+000  5.1950000e+000  5.2100000e+000  4.8625000e+000  4.7000000e+000  4.7800000e+000  4.6890000e+000  4.9095000e+000  4.7050000e+000  4.2100000e+000  4.0350000e+000  4.3100000e+000
        4.0700000e+000  4.3308000e+000  4.3980000e+000  4.1400000e+000  4.3000000e+000  4.2405000e+000  3.8855000e+000 -1.0000000e+000  4.5600000e+000  4.2700000e+000  3.6740000e+000  3.7745000e+000  4.2750000e+000  4.0000000e+000  3.5765000e+000  3.3580000e+000  4.1400000e+000  4.0300000e+000  3.6025000e+000  3.3390000e+000  4.1950000e+000  4.0330000e+000  3.7150000e+000  3.7100000e+000  3.4270000e+000  3.1820000e+000  3.3130000e+000  3.3510000e+000  3.0105000e+000  3.2220000e+000  3.2900000e+000  2.7700000e+000  2.7950000e+000  2.8100000e+000
        8.1700000e-001  8.7600000e-001  8.1000000e-001  7.5500000e-001  7.8000000e-001  7.9850000e-001  7.7650000e-001 -1.0000000e+000  7.9500000e-001  7.4500000e-001  7.0050000e-001  6.8100000e-001  7.3500000e-001  7.1000000e-001  6.4300000e-001  6.1900000e-001  7.2000000e-001  6.4500000e-001  6.4800000e-001  6.0900000e-001  6.9000000e-001  6.6500000e-001  6.1500000e-001  5.9500000e-001  6.0600000e-001  6.0950000e-001  5.3500000e-001  5.4000000e-001  5.4950000e-001  6.2700000e-001  5.6000000e-001  4.8500000e-001  4.9500000e-001  5.4000000e-001
        0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000  0.0000000e+000
        7.9900000e-001  8.1240000e-001  7.8000000e-001  7.4500000e-001  7.8000000e-001  8.0850000e-001  7.5400000e-001 -1.0000000e+000  8.0000000e-001  7.6500000e-001  7.2550000e-001  7.1150000e-001  7.6650000e-001  7.0000000e-001  6.6150000e-001  6.3750000e-001  7.0000000e-001  7.3500000e-001  7.0150000e-001  6.7900000e-001  7.5000000e-001  7.2500000e-001  6.5500000e-001  6.7500000e-001  6.5400000e-001  7.3800000e-001  6.5000000e-001  6.4500000e-001  6.4800000e-001  7.7350000e-001  7.0500000e-001  5.9500000e-001  6.1500000e-001  6.6500000e-001
    ];

    % ********** Define components for plotting **********
    plot_list = ['ER00010   '; 'ER00017   '; 'ER00013   '; 'ER00008   '; 'ER00002   '; ...
                 'ER00021   '; 'ER00009   '; 'ER00006   '; 'ER00007   '; 'ER00015   '; ...
                 'ER00004   '; 'ER00011   '; 'ER00016   '; 'ER00005   '; 'ER00023   '];
    [plot_count, dont_care] = size(plot_list);
    labels = ['A';'D';'E';'F';'G';'I';'K';'L';'M';'P';'R';'S';'T';'V';'Y';];            
    
    % ********** Display starting message **********
    disp('***************************************************');
    disp('************** Starting Simulation ****************');
    disp('***************************************************');
    
    % ********** Load network structure & details **********
    [Aeq f bounds placeIds transitionIds geneIds Gene_ReactionTable] = loadNetwork();
    [mediumCompounds initialMediumAmounts uptakeRates] = initializeMedium();            
    mediumAmounts = initialMediumAmounts;    
    b = zeros(length(Aeq(:, 1)), 1);               
    
    % ********** Define matrices to hold histories **********
    klett_history = zeros(1, 1);
    time_history = zeros(1, 1);
    fluxes_history = zeros(1, length(Aeq(1, :)));
    historyCtr = 0;
    
    % ********** Initialize record (plotting) variables **********
    recordPoints = ceil((END_TIME - START_TIME) / DELTA_TIME);
    klett_series = zeros(1, recordPoints);
    time_series = zeros(1, recordPoints);
    measurements_series = zeros(20, recordPoints);        
    
    % ********** Begin actual growth simulation **********
    display('Starting Growth....');
    klett = INITIAL_KLETT;
    deltaKlett = 0;
    [mediumCompoundsCount, n] = size(mediumCompounds);

    ctr = 0;
    for t = START_TIME : DELTA_TIME : END_TIME                                
        display(sprintf('time: %f    klett: %.7f     deltaKlett: %.7f', t, klett, deltaKlett));        
        ctr = ctr + 1;
        time_series(ctr) = t;
        klett_series(ctr) = klett;
        for i = 1 : plot_count
            measurements_series(i, ctr) = mediumAmounts(listIndexOfString(mediumCompounds, plot_list(i, :)));
        end
    
        % Compute maximum uptake amounts
        maximum_uptakes = zeros(mediumCompoundsCount, 1);
        for i = 1 : mediumCompoundsCount
            maximum_uptakes(i) = uptakeRates(i) * klett * DELTA_TIME * MEASUREMENT_VOLUME_MICROL;
            % Make sure that amount taken up does not exceed amount in medium
            if maximum_uptakes(i) > mediumAmounts(i)
                maximum_uptakes(i) = mediumAmounts(i);
            end
        end
        
        % Create the linear optimization problem
        lb = bounds(:, 1);
        ub = bounds(:, 2);        
        for i = 1 : mediumCompoundsCount            
            lb(listIndexOfString(transitionIds, mediumCompounds(i, :))) = -100000000;
            ub(listIndexOfString(transitionIds, mediumCompounds(i, :))) = maximum_uptakes(i);
        end

        % ***** Energy requirements *****
        Aeq(listIndexOfString(placeIds, 'CX00006'), listIndexOfString(transitionIds, 'ER90000')) = 0;     
        lb(listIndexOfString(transitionIds, 'R00086')) = ATP_ATTO_MOL_PER_HOUR_KLETT_ML * (DELTA_TIME) * klett * (MEASUREMENT_VOLUME_MICROL / 1000) * 3.65E-9; %* 0.69E-9;   
        %ub(listIndexOfString(transitionIds, 'R00086')) = lb(listIndexOfString(transitionIds, 'R00086'));
                
        % ***** Remove redundant reactions to prevent type III extreme pathways and 2 component loops (ex. NADPH NADH cycling) *****
        lb(listIndexOfString(transitionIds, 'R01325')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R01325')) = 0.0;
        lb(listIndexOfString(transitionIds, 'R01899')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R01899')) = 0.0;
        lb(listIndexOfString(transitionIds, 'R02984')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R02984')) = 0.0;
        lb(listIndexOfString(transitionIds, 'R02164')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R02164')) = 0.0;        
        ub(listIndexOfString(transitionIds, 'R02014')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R02022')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R02020')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R02023')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R00691')) = 0.0;
        lb(listIndexOfString(transitionIds, 'R04326')) = 0.0;
        lb(listIndexOfString(transitionIds, 'R00243')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R01975')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R01976')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R01977')) = 0.0;                
        ub(listIndexOfString(transitionIds, 'R00671')) = 0.0;
        ub(listIndexOfString(transitionIds, 'R00214')) = 0.0;        
        ub(listIndexOfString(transitionIds, 'R00216')) = 0.0;        

        ctype={}; for i=1:643; ctype{i}='S'; end
        vtype={}; for j=1:780; vtype{j}='C'; end
        sense=-1;        

        dir_list = {'Aeq','lb','ub','f','b','fluxes'};
        for dl=1:length(dir_list)
            if ~exist(strcat('./_main_output/',dir_list{dl}),'dir')
                mkdir(strcat('./_main_output/',dir_list{dl}))
            end
        end
        
        filename=strcat('./_main_output/Aeq/Aeq-',num2str(ctr),'.txt');
        dlmwrite(filename,Aeq,'precision',24);
        filename=strcat('./_main_output/lb/lb-',num2str(ctr),'.txt');
        dlmwrite(filename,lb,'precision',24);
        filename=strcat('./_main_output/ub/ub-',num2str(ctr),'.txt');
        dlmwrite(filename,ub,'precision',24);
        filename=strcat('./_main_output/f/f-',num2str(ctr),'.txt');
        dlmwrite(filename,f,'precision',24);
        filename=strcat('./_main_output/b/b-',num2str(ctr),'.txt');
        dlmwrite(filename,b,'precision',24);
        
        % Perform FBA        
        [x fval sol_status] = glpk(f, Aeq, b, lb, ub,char(ctype),char(vtype),sense);  
        historyCtr = historyCtr + 1;
        klett_history(historyCtr) = klett;
        time_history(historyCtr) = t;
        fluxes_history(historyCtr, :) = x'; 
                
        % Check the status of the solution
        % <FM> Modified to match status dictated by GLPK (not LP)</FM>
        if (sol_status == 1)
            error('Error: Solution is undefined');
        elseif (sol_status == 2)
            fprintf('Warning: Solution found is possibly not optimal! \\nSolution has only been determined to be feasible');
        elseif (sol_status == 3)
            error('Error: Solution found is infeasible!');
        elseif (sol_status == 4)
            error('Error: No feasibel solution exists');
        elseif (sol_status == 5)
            disp('Solution is Optimal!');
        elseif (sol_status == 6)
            error('Error: LP has unbounded solution!');
        end
                
        % Cells produced per measurement volume unit
        cellsPerVolumeUnit = fval * 1.0E-9/1.0E-18;                  
        % Compute cells per ml
        cellsPerML = cellsPerVolumeUnit * 1.0E-3 / (MEASUREMENT_VOLUME_MICROL * 1.0E-6);         
        %update medium
        for i = 1 : mediumCompoundsCount            
            mediumAmounts(i) = mediumAmounts(i) - x(listIndexOfString(transitionIds, mediumCompounds(i, :)));
        end
        % Compute change in klett
        deltaKlett = (cellsPerML / CELLS_PER_OD_ML) * 100;
        klett = klett + deltaKlett;
        
        % Output fluxes
         writeFluxFile(strcat('./_main_output/fluxes/fluxesAtTime-', num2str(t + DELTA_TIME), '.txt'), transitionIds, x);
    end
    
    % ********** Save History **********
    klett_history = klett_history';
    save './_main_output/zzz_klett.txt' klett_history -ascii;
    time_history = time_history';
    save './_main_output/zzz_time.txt' time_history -ascii;
    fluxes_history = fluxes_history';
    save './_main_output/zzz_fluxes.txt' fluxes_history -ascii;
