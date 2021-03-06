%makes a classifier 





function labels =  sift_matching(ref_frames,ref_descriptors, ref_labels, test_frames,test_descriptors)
%
%
%
%     ref_frames  - sift frames
%

    test_labels = cell(1,length(test_frames));


    for i=1:length(test_frames)
        i
        best_label = 'none';
        highest_matches = 0;
        
        
        for j=1:length(ref_frames)
            
            cur_matches = get_matches(ref_frames{j},ref_descriptors{j}, test_frames{i},test_descriptors{i});
            
            if(length(cur_matches) > highest_matches)
                best_label = ref_labels(j);
                highest_matches = length(cur_matches);
            end
            
        end%for j, each ref_frame
        
        test_labels(i) = best_label;
    end%for i, each test frame


    
    labels = test_labels;
    
end% function sift_matching











function matches = get_matches(frames1,descrs1,frames2,descrs2)


    % Find the top two neighbours as well as their distances
    [nn, dist2] = findNeighbours(descrs1, descrs2, 2) ;

    % Accept neighbours if their second best match is sufficiently far off
    nnThreshold = 0.8 ;
    ratio2 = dist2(1,:) ./ dist2(2,:) ;
    ok = ratio2 <= nnThreshold^2 ;

    % Construct a list of filtered matches
    matches_2nn = [find(ok) ; nn(1, ok)] ;

    % Alternatively, do not do the second nearest neighbourhood test.
    % Instead, match each feature to its two closest neighbours and let
    % the geometric verification step figure it out (in stage I.D below).

    %matches_2nn = [1:size(nn,2), 1:size(nn,2) ; nn(1,:), nn(2,:)] ;


    %               Stage I.D: Better matching w/ geometric transformation
   % [inliers, H] = geometricVerification(frames1, frames2, matches_2nn, 'numRefinementIterations', 3) ;
   % matches_geo = matches_2nn(:, inliers) ;










    %matches = matches_geo;
    matches = matches_2nn;

end%funciton get matches