% This function calculates quantile of patient survivals in terms of given 
% median value
% also returns their numeric values and patient mRNA data subset
% long_survivor = 1, short_survior = -1, others = 0
% Date: 19.05.2016
% Duygu Özçelik
function [filteredClinicalSet, numLabels, genomeSetAvailableClinic, overall_last, vital, patients]= quantileCalculatorPercentage(clinicalSet, mainGenomSet, lowVal, upVal)

    patientsClinical = clinicalSet.sampleID;
    [commonPatients,idataset,isurv] = intersect(mainGenomSet.Properties.ObsNames,patientsClinical);
    genomeSetAvailableClinic = mainGenomSet(idataset,:);
    filteredClinicalSet = clinicalSet(isurv,:);
    survived = filteredClinicalSet.days_to_last_followup;
    dead = filteredClinicalSet.days_to_death;
    patients = filteredClinicalSet.sampleID;
    vital_status = filteredClinicalSet.vital_status;
    %overall survival
    overall = zeros(size(commonPatients,1),1);

    vital = zeros(size(commonPatients,1),1);
    %choose available daily survival data from set of all patients
    for ii = 1:size(overall,1)
        if(isnan(survived(ii,1)) && isnan(dead(ii,1)))
           overall(ii,:) = NaN; 
           patients{ii,1} = [];
     elseif(~isnan(survived(ii,1)) && isnan(dead(ii,1)))
            overall(ii,:) = survived(ii,1);   
        else
            overall(ii,:) = dead(ii,1);  
        end
        if (strcmp(vital_status(ii,1), 'DECEASED'))
            vital(ii,:) = 1;
        elseif (strcmp(vital_status(ii,1), 'LIVING'))
             vital(ii,:) = 0;
        end
    end

    %omit empty rows from matrix
    overall_last = overall(~isnan(overall));
    vital = vital(~isnan(overall));
    genomeSetAvailableClinic = genomeSetAvailableClinic(~isnan(overall),:);
    filteredClinicalSet = filteredClinicalSet(~isnan(overall),:);
    patients = patients(~cellfun('isempty',patients));
    %initialize label vectors

    numLabels = zeros(size(overall_last,1) , 1);

    %format low value and up value in percentage
    lowVal = lowVal * 0.01;
    upVal = upVal * 0.01;

    %find lower and upper quantiles of survival days of patients
    brQuantile = quantile(overall_last,[lowVal upVal]);
    brQuantileLow = brQuantile(1,1);
    brQuantileUp = brQuantile(1,2);
    
    fprintf ('Lower quantile: %.2f months\n', (brQuantileLow/30));
    fprintf ('Upper quantile: %.2f months\n', (brQuantileUp/30));
    
    longSurvival  = logical(overall_last  >= brQuantileUp);
    %shortSurvival = logical((overall <= brQuantileLow) & (vital == 1)); %get only deceased people with low survival
    shortSurvival = logical(overall_last <= brQuantileLow);
    
    numLabels(longSurvival == 1) = 1;
    numLabels(shortSurvival == 1) = -1;
    
    
    fprintf ('Number of all patients in dataset: %d\n\n', size(overall_last,1));
    fprintf ('Number of long survivors: %d\n', sum(longSurvival));
    fprintf ('Number of short survivors: %d\n', sum(shortSurvival));
    fprintf ('Total patients used: %d\n', sum(shortSurvival)+sum(longSurvival));

end

