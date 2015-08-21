%% Many fits to Firas' data

filename    = './_main_scripts/_output/growth_measurements_actual.csv';
actual      = growthFit5(filename); % generate a cell array with the data
plate       = actual;

fileID = fopen('./_main_scripts/_output/growth_measurements_actual_fitted.csv','w');
fprintf(fileID,'well number,strain,logistic R^2,logistic doubling time [min],logistic max growth rate [per hr],logistic carrying capacity,logistic growth infleciton time [hr],gompertz R^2,gompertz max growth rate,gompertz carrying capacity,gompertz lag time [hr]\r\n');
for i=1:1
% Generate a CSV table with all the data
fprintf(fileID,'%d,%s,%s,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f',i,plate{i}.mutant,...
        plate{i}.logistic.R2,plate{i}.logistic.doublingTime,plate{i}.logistic.maxGrowthRate,plate{i}.logistic.carryingCapacity,plate{i}.logistic.growthInflection,plate{i}.gompertz.R2,plate{i}.gompertz.maxGrowthRate,plate{i}.gompertz.carryingCapacity,plate{i}.gompertz.lagTime);
fprintf(fileID,'\r\n');
end
fclose(fileID);

filename    = './_main_scripts/_output/growth_measurements_simulated.csv';
simulated   = growthFit5(filename); % generate a cell array with the data
plate       = simulated;

fileID = fopen('./_main_scripts/_output/growth_measurements_simulated_fitted.csv','w');
fprintf(fileID,'well number,strain,logistic R^2,logistic doubling time [min],logistic max growth rate [per hr],logistic carrying capacity,logistic growth infleciton time [hr],gompertz R^2,gompertz max growth rate,gompertz carrying capacity,gompertz lag time [hr]\r\n');
for i=1:2
% Generate a CSV table with all the data
fprintf(fileID,'%d,%s,%s,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f',i,plate{i}.mutant,...
        plate{i}.logistic.R2,plate{i}.logistic.doublingTime,plate{i}.logistic.maxGrowthRate,plate{i}.logistic.carryingCapacity,plate{i}.logistic.growthInflection,plate{i}.gompertz.R2,plate{i}.gompertz.maxGrowthRate,plate{i}.gompertz.carryingCapacity,plate{i}.gompertz.lagTime);
fprintf(fileID,'\r\n');
end
fclose(fileID);
