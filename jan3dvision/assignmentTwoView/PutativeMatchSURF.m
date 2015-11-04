function [idxs] = PutativeMatchSURF(features1,features2)
%
%  features1 matrix of size no-features x 64 which in the i-th row has 
%            the values of the descriptor of the i-th feature of the first
%            image
%  features2 the feature descriptors for the second image
%
%  idxs      matrix of size no matches x 2 with each row consisting of the
%            feature index for the first image in the first column and the 
%            matching features index in the second image. If a feature does
%            not match no row is provided for the feature



    %thresh = double(.05);
   
    %find nearest neighnor in both directions
    [nn_of_2_in_1 dists]  = knnsearch(features1,features2);
    [nn_of_1_in_2 dists]  = knnsearch(features2,features1);
    
    
    %only keep points that were each others nearset neighbors
    two_way_nn_of_1_in_2 = nn_of_1_in_2;
    
    for i=1:length(nn_of_1_in_2)
        index2 = nn_of_1_in_2(i);
        if(i  == nn_of_2_in_1(index2))
            continue;
        end
        two_way_nn_of_1_in_2(i) = 0;
    end
        
        
    indices1 = find(two_way_nn_of_1_in_2);
    indices2 = two_way_nn_of_1_in_2(indices1);
    
    idxs = [indices1 indices2];
    
    %idxs = [one_way_ids [1:length(one_way_ids)]'];
    
    save('idxs.mat','idxs');
    
    

end