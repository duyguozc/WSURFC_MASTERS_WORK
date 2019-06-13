%This function generates a random height for each tree in random forest,
%extracts similarity matrix for observation
%return two things each d sampled for  each tree 
%(in the order they were generated) and the observation matrices calculated on each tree
%Duygu Özçelik
%Date:02.08.2014
function [depthVector,obsMatrix] = bag_get_obs_sim(bag, names, matrix, depthStart, depthEnd)
    numTrees = size(bag.Trees,2);
    %Create a double array which keeps variable random depth for each trees
    depthVector = zeros(numTrees,1);
    %Create a cell array keeps observation-observation matrix for each tree
    obsMatrix = cell(numTrees,1);
    for t = 1 : numTrees
        tree = bag.Trees{1,t}; %it returns decision tree object
        numnodes = tree.NumNodes; %get total number of nodes
        height = ceil(log2(numnodes)); %calculate height of tree
        %fprintf ('Height: %d \n', height);
        % generate a random integer within uniform distribution
        rng('shuffle')
        %depth = randi([(height * katsayi) (height * (katsayi+ 1/3) )],1,1);
        a = height * depthStart;
        b = height * depthEnd;
        depth = (b-a).*rand(1,1) + a;
        depth = floor(depth);
        if(depth == 0)
            depth = 1;
        end
        A =  tree_get_obs_sim_atdepth(tree,depth,height, names, matrix);
        depthVector(t,1) = depth;
        fprintf ('Depth: %d \n', depth);
        obsMatrix{t,1} = A;
    end
end
