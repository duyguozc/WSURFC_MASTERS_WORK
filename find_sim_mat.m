% Extract similarity matrix of observations by calcluating ratio of number 
% of times two observations fall in same node and number of times these two
% involved as train sample for current tree in random forest
function [similarityMatrix, depthVector] = find_sim_mat(bag, obsnames, matrix, depthStart, depthEnd)
    obsSize = size(obsnames,1);
    %bag = TreeBagger(200,set,numeric_cls,'Method','Classification','oobpred','on');
    % give depth parameter constant for trees in random forest
 [depthVector,obsMatrix] = bag_get_obs_sim(bag, obsnames, matrix, depthStart, depthEnd);
    %  OOBIndices is logical array of size Nobs-by-NTrees, where Nobs is the number of observations 
    % in the training data and NTrees is the number of trees in the ensemble. A true value for the 
    % (i,j) element indicates that observation i is out-of-bag for tree j.
    isIncludedInBag = ~bag.OOBIndices;    
    % Create a similarity matrix for all observation pairs
    similarityMatrix = zeros(obsSize,obsSize);
    for r = 1  : obsSize
        for c = 1 : obsSize
                % Find total number of pairs which fall in same node
                noOfFallingSameNode = sum(cellfun(@(x) x(r, c), obsMatrix)' & isIncludedInBag(r,:) & isIncludedInBag(c,:));
                % Find total number of trees in which both pairs are used as
                % observations
                totalNumberOfInvolment = sum(isIncludedInBag(r,:) & isIncludedInBag(c,:));
                similarityMatrix(r, c) = noOfFallingSameNode / totalNumberOfInvolment;
        end
    end
end





