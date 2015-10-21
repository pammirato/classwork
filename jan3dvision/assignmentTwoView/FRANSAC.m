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

    for i=1:10000

    %1) Select a random minimal set from all potential correspondences
    rand_indices = randi(length(matchedPoints1),[1 8]);
    points1 = matchedPoints1(rand_indices,:)';
    points2 = matchedPoints2(rand_indices,:)';
    
    
    %2) Compute	a solution from the minimal samples	
        %a)normalize the data
            %i) shift mean to [0,0]
            %init_all = init_all - mean(init_all);

            transform1 = get_normaliztion_transform(points1);
            transform2 = get_normaliztion_transform(points2);
            
            homog1 = [points1; ones(1,length(points1))];
            homog2 = [points2; ones(1,length(points2))];
            
            norm_points1 = transform1 * homog1;
            norm_points2 = transform2 * homog2;

            norm_points1 = norm_points1(1:2,:);
            norm_points2 = norm_points2(1:2,:);
            
            
            
            
        %b)
        %left = helper(norm_points1',norm_points2');
        left = helper(norm_points2',norm_points1');
        
        [~, ~, eigv] = svd(left,0);
        f = eigv(:,end);
        
        %reshape
        f = reshape(f,3,3)';
        
        %rank 2
        [u, s, v] = svd(f);
        %s(1,1) =1;
        %s(2,2) = 1;
        s(end) = 0;
        norm_f = u*s*v';
        
        
        F = transform2' * norm_f * transform1;
            
        
        %lose the points used to generate F
        test_points1 = matchedPoints1';
        test_points1(:,rand_indices) = [];
        
        test_points2 = matchedPoints2';
        test_points2(:,rand_indices) = [];
        
        
        test_left = helper(test_points1',test_points2');
        
        unrolled_F = reshape(F',9,1);
        
       
        test_results = test_left * unrolled_F;
     
        
        
        thresholded_results = test_results;
        thresholded_results(abs(thresholded_results) > threshold) = 0;
        
        inliers = find(thresholded_results);
        
        if(length(inliers) > length(best_inliers))
            best_inliers = inliers;
            best_F = F; 
        end
        
        
        
            
%         %randomly permutate the remaining points
%         rand_order = randperm(length(test_points1));
% 
%         test_points1 = test_points1(:,rand_order);
%         test_points2 = test_points2(:,rand_order);
%         
%         truncate = mod(length(test_points1),8);
%         num_groups = floor(length(test_points1)/8);
%         
%         test_groups1 = reshape(test_points1(:,1:end-truncate),2,8,num_groups);
%         test_groups2 = reshape(test_points2(:,1:end-truncate),2,8,num_groups);
%         
        
        


    
    
    
    end%for i = 1000
    
    
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




