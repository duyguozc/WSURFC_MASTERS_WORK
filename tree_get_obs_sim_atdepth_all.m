   % This function creates a mxm similarNodes matrix from m observations
   % with given depth and tree
   % If observation i and j falls withn same node similarNodes(i,j) = 1
   % Date: 03.06.2016
function [similarNodes] = tree_get_obs_sim_atdepth_all(tree, depth, height, observations, mt)  
    noOfObservations = size(observations,1);

    % An n-element vector of the values used as cut points in tree, where n is the number of nodes
    cutPoints = tree.CutPoint;
    % An n-by-2 array containing the numbers of the child nodes for each node in tree, 
    % where n is the number of nodes. Leaf nodes have child node 0.
    children = tree.Children;
    
    % An n-element cell array of the names of the variables used for branching in each node in tree, 
    % where n is the number of nodes. For leaf nodes, CutVar contains an empty string.
    cutVariables = tree.CutVar;
    %Cell array of strings containing the predictor names, in the order which they appear in X.
    predictors = tree.PredictorNames;

    %Create a dataset object from measurements
    ds = mat2dataset(mt,'ObsNames', observations, 'VarNames', predictors);
    
    %[bb,ipred,~] = intersect(predictors,cutVariables);
    %emptyCellsLogic = cellfun('isempty',cutVariables);
    %cutVariables
    
    %Create a matrix which keeps the corresponding node of an observation
    M = zeros(noOfObservations,1);
   

    %Find node location of all observations in current tree
    for ii = 1 : noOfObservations
        currNode=1;
        %leafNode = '';
        stepCount = 0; %checks depth of traversal
        while stepCount <= depth && stepCount < height
            stepCount = stepCount + 1;
          if(~strcmp(cutVariables(currNode,1),''))
              obs = ds{ii,cutVariables(currNode,1)}; %get value of cutting predictor from current observation
              cutVal = cutPoints(currNode,1);
              if(obs < cutVal)
                  currNode = children(currNode,1); %go to left child
              else
                  currNode = children(currNode,2); %go to right child
              end
          end
        end
        % Put node number on which the observation falls
        M(ii,1) = currNode;
    end
    
    %Create a m x m matrix for m number of observations
    similarNodes = zeros(noOfObservations, noOfObservations);
   
    for m = 1 : noOfObservations
        for k = 1: noOfObservations
            if(M(m,1) == M(k,1))
                similarNodes(k,m) = 1;
                
            end
        end
    end
 

end









