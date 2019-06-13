%This function generates a random height for each tree in random forest,
%extracts similarity matrix for observation
%return two things each d sampled for  each tree 
%(in the order they were generated) and the observation matrices calculated on each tree
%Duygu Özçelik
%Date:03.06.2016
function [obsMatrix] = bag_get_obs_sim_all(bag, names, matrix, depths)
    numTrees = size(bag.Trees,2);
    %Create a double array which keeps variable random depth for each trees
    depthVector = zeros(numTrees,1);
    %Create a cell array keeps observation-observation matrix for each tree
    obsMatrix = cell(numTrees,1);
    for t = 1 : numTrees
        tree = bag.Trees{1,t}; %it returns decision tree object
        numnodes = tree.NumNodes; %get total number of nodes
        height = ceil(log2(numnodes)); %calculate height of tree        
        depth = depths(t);
        A =  tree_get_obs_sim_atdepth_all(tree,depth,height, names, matrix);
        depthVector(t,1) = depth;
        fprintf ('Depth: %d \n', depth);
        obsMatrix{t,1} = A;
    end
end
