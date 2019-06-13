
for m = 2 : 6
    [clusterLabels] = tblread(strcat(fileDest,'hclustk=',num2str(m),'.txt'), '\t');
    save(strcat(fileDest,'allInfo',num2str(m),'.mat'),'clusterLabels','overall','vital_status');
end

