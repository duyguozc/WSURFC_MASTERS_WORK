% Extract similarity matrix of train+test+non low-survivor observations by calcluating ratio of number 
% of times two observations landed in same node and number of total trees
function [similarityMatrix] = find_sim_all(bag, obsnames, matrix, depths)
    obsSize = size(obsnames,1);
    %bag = TreeBagger(200,set,numeric_cls,'Method','Classification','oobpred','on');
    % give depth parameter constant for trees in random forest
    [obsMatrix] = bag_get_obs_sim_all(bag, obsnames, matrix, depths);

    % Create a similarity matrix for all observation pairs
    similarityMatrix = zeros(obsSize,obsSize);
    for r = 1  : obsSize
        for c = 1 : obsSize
                % Find total number of pairs which fall in same node
                noOfFallingSameNode = sum(cellfun(@(x) x(r, c), obsMatrix));
                similarityMatrix(r, c) = noOfFallingSameNode / size(bag.Trees,2);
        end
    end
end





