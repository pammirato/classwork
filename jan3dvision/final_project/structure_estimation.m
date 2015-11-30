
%load_all;


ref_index = 5;
ref_img = all_images(:,:,:,ref_index);
ref_data = all_camera_data(ref_index,:);

other_imgs = all_images(:,:,:,1:10);
other_imgs(:,:,:,ref_index) = [];

other_data = all_camera_data(:,1:10);
other_data(ref_index,:) = [];


down_sample_rate = 2;

ref_P = reshape(ref_data(1:12),3,4);
ref_K = reshape(ref_data(13:21),3,3);
ref_R = reshape(ref_data(22:30),3,3);
ref_C = ref_data(31:end)';

assert(max(max(abs(ref_P - ref_K*[ref_R' -ref_R'*ref_C]))) < .1);


ref_K_inv = pinv(ref_K);


%%%%%%% matrix to normalize R and C for each image
transform_matrix = [ref_R' -1*ref_R'*ref_C; 0,0,0,1];

org_ref_R = ref_R;
org_ref_C = ref_C;



plane_distances = [5:.5:12 13:20]; % [1:.5:5];
plane_normal = [0 0 1];



avg_ref_img_value = sum(sum(sum(ref_img)))/(size(ref_img,1)*size(ref_img,2));


gain_ratios = ones(1,size(other_imgs,4));

for i=1:size(other_imgs,4)
    
    avg = sum(sum(sum(other_imgs(:,:,:,i))) )/ ...
        (size(other_imgs(:,:,:,i),1)*size(other_imgs(:,:,:,i),2)) ;
    
   gain_ratios(i) =  avg / avg_ref_img_value ;
        
    
end%for i







%5D array, image(width, height , RGB,), number of images, number of planes
all_costs = zeros(size(ref_img,1)/down_sample_rate,size(ref_img,2)/down_sample_rate,3,size(other_imgs,4),length(plane_distances));

all_costs_window = all_costs;
all_costs_window2 = all_costs;
all_costs_window3 = all_costs;
all_costs_window4 = all_costs;

%for each plane
for i =1:length(plane_distances)
    cur_dist = plane_distances(i)
    
    %for each image, not the reference
    for j=1:size(other_imgs,4)
        
        cur_img = other_imgs(:,:,:,j);
        
        camera_data = all_camera_data(j,:);
        P = reshape(camera_data(1:12),3,4);
        K = reshape(camera_data(13:21),3,3);
        R = reshape(camera_data(22:30),3,3);
        C = camera_data(31:end)';
        
        assert(max(max(abs(P - K*[R' -R'*C]))) < .1);
        
        
        aug_matrix = transform_matrix * [R C; 0,0,0,1];
        
        R = aug_matrix(1:3,1:3);
        C = aug_matrix(1:3,4);
        
        
        
       
        %pinv is the inverse of a matrix
        H = K * (R' - (R'*C*plane_normal)/cur_dist) * ref_K_inv;
        
        %all_trans_coords = zeros(size(ref_img,1),size(ref_img,2),2);
        
        
        new_image = zeros(size(ref_img,1)/down_sample_rate,size(ref_img,2)/down_sample_rate,3);
        
      
        
        for ii=1:down_sample_rate:size(ref_img,1)
            for jj=1:down_sample_rate:size(ref_img,2)
                homog_coords = [jj ii 1]';
                
                %trsnformed coordinates
                trans_coords = H * homog_coords;
                
                %divide by w
                trans_coords = trans_coords ./trans_coords(3);
                
                
                %for index to matrix
                x = floor(trans_coords(1));
                y = floor(trans_coords(2));
                
                
                %all_trans_coords(ii,jj,:) = trans_coords(1:2);
                
                if(y > 0 && y < size(cur_img,1) && x >0 && x<size(cur_img,2))
                
                    %give new image the intensity from not the reference
                    new_image(floor(ii/down_sample_rate) + 1, floor(jj/down_sample_rate) + 1,:) ...
                              = cur_img(y,x,:);
                end
                
                breakp = 1;
                
                
            end%jj
        end%ii
        
        
        breakp = 1;
        
        

        abs_diff = abs(ref_img(1:down_sample_rate:end,1:down_sample_rate:end,:) ...
                   - gain_ratios(j)*new_image);
        
        
        all_costs(:,:,:,j,i) = abs_diff;
        
        
        window = ones(3,3);
        all_costs_window(:,:,:,j,i) = imfilter(abs_diff,window);
        
        window2 = ones(9,9);
        all_costs_window2(:,:,:,j,i) = imfilter(abs_diff,window2);
        
        window3 = ones(6,6);
        all_costs_window3(:,:,:,j,i) = imfilter(abs_diff,window3);
        
        window4 = ones(20,20);
        all_costs_window4(:,:,:,j,i) = imfilter(abs_diff,window4);
        
        
        
    end%for j, each image
        
    
    
end%for i, each plane



summed_costs_over_images = sum(all_costs,3);
min_per_image = min(summed_costs_over_images,[],4);
[min_per_plane, I] = min(min_per_image,[],5);


summed_window_costs_over_images = sum(all_costs_window,3);
min_window_per_image = min(summed_window_costs_over_images,[],4);
[min_window_per_plane, I_window] = min(min_window_per_image,[],5);

summed_window_costs_over_images2 = sum(all_costs_window2,3);
min_window_per_image2 = min(summed_window_costs_over_images2,[],4);
[min_window_per_plane2, I_window2] = min(min_window_per_image2,[],5);

summed_window_costs_over_images3 = sum(all_costs_window3,3);
min_window_per_image3 = min(summed_window_costs_over_images3,[],4);
[min_window_per_plane3, I_window3] = min(min_window_per_image3,[],5);

summed_window_costs_over_images4 = sum(all_costs_window4,3);
min_window_per_image4 = min(summed_window_costs_over_images4,[],4);
[min_window_per_plane4, I_window4] = min(min_window_per_image4,[],5);


depth = zeros(size(I));
depth_window = zeros(size(I));
depth_window2 = zeros(size(I));
depth_window3 = zeros(size(I));
depth_window4 = zeros(size(I));


% for ii=1:size(I,1)
%     for jj=1:size(I,2)
%         
%         x = (jj-1)*down_sample_rate + 1;
%         y = (ii-1)*down_sample_rate + 1;
%         
%         homog_coords = [x y 1];
%         
%         dm = plane_distances(I(ii,jj));
%         depth(ii,jj) = dm / (homog_coords * ref_K_inv' * plane_normal');
%         
%         
%         dm_window = plane_distances(I_window(ii,jj));
%         depth_window(ii,jj) = dm_window / (homog_coords * ref_K_inv' * plane_normal');
% 
%         
%     end%for ii
% end%for jj


depth = plane_distances(I);
depth_window = plane_distances(I_window);
depth_window2 = plane_distances(I_window2);
depth_window3 = plane_distances(I_window3);
depth_window4 = plane_distances(I_window4);


%use min



