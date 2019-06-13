expressionDataDir = 'D:\thesis_data\TCGA_BRCA_miRNA-2015-02-24\genomicMatrix';
clinicalSetDir = 'D:\thesis_data\TCGA_BRCA_miRNA-2015-02-24\clinical_data';

[survivalIndices, selected_indices, allClinicalSet, dataMatrix, numeric_cls, overall, vital_status,...
    patients, trainMatrix, trainClass, testMatrix, testClass, trainPatients, testPatients, forest_brca] = train_BRCA_data(expressionDataDir, clinicalSetDir, 200, 100, 25, 75);    

% depth interval (tree height) * 1/3 - (tree height) * 2/3 gives best
% result
[simMat, depthVector] = find_sim_mat(forest_brca, trainPatients, trainMatrix, 1/3, 2/3);

%find similarity of all, train+test+non low-survivor by using depth values
%of train model
[simMatAll] = find_sim_all(forest_brca, patients, dataMatrix(:,selected_indices), depthVector);

%save your similarity matrix to a folder you want, then you will read the
%matrix with R script
fileDest = 'C:\Users\user\Documents\Research\';
save(strcat(fileDest,'allInfo.mat'),'simMatAll');

%in order to plot survival graphics, generate a mat file containing overall
%survival time of all patients and their vital status (dead = 1, alive = 0)
save(strcat(fileDest,'survivalinfo.mat'),'overall','vital_status');

