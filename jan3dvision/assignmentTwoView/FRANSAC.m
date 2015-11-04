function [F,inliers]=FRANSAC(matchedPoints1, matchedPoints2,probSol,threshold)
%
%  matchedPoints1, matchedPoints2 matrix of size no_matches x 2 containing
%                                 the x, y coordinates of all matched 
%                                 features in image 1,2 respectively
%
%  probSol  probability of having seen a good solution before stopping. 
%           Typically,this should be 0.95 to 0.99
%  
%  threshold inlier threshold typical ranges between 1 und 4 pixels
%
%

% 

    best_F = eye(3,3);
    %F=eye(3);
    best_inliers = 0;
    
    
    
    N = 99999;
    sample_count = 0;
    
    while (N> sample_count)

    %for i=1:10

    %1) Select a random minimal set from all potential correspondences
    rand_indices = randi(length(matchedPoints1),[1 8]);
    points1 = matchedPoints1(rand_indices,:)';
    points2 = matchedPoints2(rand_indices,:)';
    
    
    %2) Compute	a solution from the minimal samples	
        %a)normalize the data
            %i) shift mean to [0,0]
            %init_all = init_all - mean(init_all);

            %get normalization transformation
            transform1 = get_normaliztion_transform(points1);
            transform2 = get_normaliztion_transform(points2);
            
            %convvert point to homogenous coords
            homog1 = [points1; ones(1,length(points1))];
            homog2 = [points2; ones(1,length(points2))];
            
            %normalize points
            norm_points1 = transform1 * homog1;
            norm_points2 = transform2 * homog2;

            %convert back from homogenous coords
            norm_points1 = norm_points1(1:2,:);
            norm_points2 = norm_points2(1:2,:);
            
            
            
            
        %b)
        %left = helper(norm_points1',norm_points2');
        left = helper(norm_points1',norm_points2');
        
        [~, ~, eigv] = svd(left);
        f = eigv(:,end);
        
        %reshape
        f = reshape(f,3,3)';
        
        %ensure rank 2 constraint
        [u, s, v] = svd(f);
        s(end) = 0;
        norm_f = u*s*v';
        
        %get the un-normalized F
        F = transform2' * norm_f * transform1;
            
        
        %lose the points used to generate F
        test_points1 = matchedPoints1';
        test_points1(:,rand_indices) = [];
        
        test_points2 = matchedPoints2';
        test_points2(:,rand_indices) = [];
        
        %normalize test points
        norm_test2  = transform2 * [test_points2; ones(1,length(test_points2))];;
        norm_test1  = transform1 * [test_points1; ones(1,length(test_points1))];;
        
        %do testing
        test_results = norm_test1' * norm_f * norm_test2;
        test_results = diag(test_results);
        
         %threshold for inliers    
        thresholded_results = test_results;
        thresholded_results(abs(thresholded_results) > (threshold/100)) = 0;
        
        inliers = find(thresholded_results);
       
        %see if this is the best so far
        if(length(inliers) > length(best_inliers))
            best_inliers = inliers;
            best_F = F; 
        end
        
        %adaptively determingly number of samples
        e =1- ( length(inliers) / length(test_points1) );
        
        N = log(1-probSol) / log(1-((1-e)^8));
        
        sample_count = sample_count + 1;
         
    
    end
    
    %return the best stuff
    F = best_F;
    inliers = best_inliers;
    
end   %FRANSAC funcition
% 
% %xx', xy', x, yx', yy', y, x', y',1
function result = helper(set1, set2)
    result = [set1(:,1).*set2(:,1) ...
              set1(:,1).*set2(:,2) ...
              set1(:,1) ...
              set1(:,2).*set2(:,1) ...
              set1(:,2).*set2(:,2) ...
              set1(:,2) ...
              set2(:,1) ...
              set2(:,2) ...
              ones(size(set1,1),1)];
          
end 
 




% %x'x, x'y, x', y'x, y'y, y', x, y, 1
% function result = helper(set1, set2)
%     result = [set1(:,1).*set2(:,1) ...
%               set1(:,1).*set2(:,2) ...
%               set1(:,1) ...
%               set1(:,2).*set2(:,1) ...
%               set1(:,2).*set2(:,2) ...
%               set1(:,2) ...
%               set2(:,1) ...
%               set2(:,2) ...
%               ones(size(set1,1),1)];
%           
% end  







function transform = get_normaliztion_transform(points)

    transform = zeros(3,3);
    
    m = mean(points');

    points(1,:) = points(1,:) - m(1);
    points(2,:) = points(2,:) - m(2);
    
    dists = sqrt(points(1,:).^2 + points(2,:).^2 );
    scale = sqrt(2)/mean(dists);
    
    transform(1,1) = scale;%scalex;
    transform(1,3) = -m(1) * scale;%transx;
    transform(2,2) = scale;%scaley;
    transform(2,3) = -m(2) *scale;%transx;
    transform(3,3) = 1;% [1 1 1];
    %transform(3,:) = [1 1 1];
    


end% get normaliztion




