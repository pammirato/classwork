




init;



object_name = 'advil_liqui_gels';  %make this = 'all' to go through all rooms

load_images = 0;
hand_label = 1;

d = dir(BASE_PATH);
d = d(3:end);

if(strcmp(object_name,'all'))
    num_objects = length(d);
else
    num_objects = 1;
end



for i=1:num_objects
    
    if(num_objects >1)
        object_name = d(i).name()
    end
    
    object_path = fullfile(BASE_PATH,object_name);
    
    bbox_path = fullfile(object_path,GROUND_TRUTH_BBOXES_DIR);
    
    mkdir(bbox_path);
    
    
    
    %% load all the images
    if(load_images)   
        dd = dir(fullfile(object_path,'*jpg'));    
        image_names = {dd.name};



        % sort the image names
            %*3 so there are extra slots, because files may have been deleted
        sorted_image_names = cell(1,length(image_names));


        %sort the original names
        for j=1:length(image_names)

            name = image_names{j};
            index1 = str2double(name(3));
            index2 = str2double(name(5:end-3))/3;



            sorted_image_names{(index1-1)*120 + index2+1} = name;

        end%for j

        image_names = sorted_image_names;


    

        all_images = cell(1,length(image_names));
        for j=1:length(image_names)
            all_images{j} = imread(fullfile(object_path,image_names{j}));
        end
    end
    
    
    %% hand label a few bboxes
   
    camera_starts = 1:600/5:600;
    
    all_bboxes = zeros(4,600);
    
    for kk=1:length(camera_starts)
    
    
        if(hand_label)
        num_to_hand_label = 8;

        hand_bboxes = zeros(4,num_to_hand_label+1);

        start_index = camera_starts(kk);
        end_index = kk*120;

        step_size = (120/num_to_hand_label);
        
        hand_indices = [start_index:step_size:end_index,end_index];

        images_to_hand_label = all_images(hand_indices);

        for j=1:length(images_to_hand_label)

            imshow(images_to_hand_label{j});

            [x,y] = ginput(2);

            hand_bboxes(:,j) = [x(1), y(1), x(2), y(2)];


        end

        end
        %% interpolate the other bboxes
        top_left_xs = zeros(1,120);
        top_left_ys = zeros(1,120);

        bottom_right_xs = zeros(1,120);
        bottom_right_ys = zeros(1,120);

        shifted_hand_indices = hand_indices - (120*(kk-1));

        for j=1:(size(hand_bboxes,2)-1)

            for k=1:4
               start_val =hand_bboxes(k,j);
               end_val = hand_bboxes(k,j+1);

               values = interpolate(start_val,end_val,length(shifted_hand_indices(j):shifted_hand_indices(j+1))-1);

               switch k
                   case 1
                       top_left_xs(shifted_hand_indices(j):shifted_hand_indices(j+1)) = values;
                   case 2
                       top_left_ys(shifted_hand_indices(j):shifted_hand_indices(j+1)) = values;
                   case 3
                       bottom_right_xs(shifted_hand_indices(j):shifted_hand_indices(j+1)) = values;
                   case 4
                       bottom_right_ys(shifted_hand_indices(j):shifted_hand_indices(j+1)) = values;
               end
            end


        end

        cur_bboxes = zeros(4,length(top_left_xs));
        cur_bboxes(1,:) = top_left_xs;
        cur_bboxes(2,:) = top_left_ys;
        cur_bboxes(3,:) = bottom_right_xs;
        cur_bboxes(4,:) = bottom_right_ys;

    
        all_bboxes(:,start_index:end_index) = cur_bboxes;
    
    
    
    end%for kk, each camera
    
    
    
%     %% transform to next camera
%     
%     imshow(all_images{121});
%         
%     [x,y] = ginput(2);
% 
%     hand_bbox_cam2= [x(1), y(1), x(2), y(2)]';
%     
%     hand_bbox_cam1 = hand_bboxes(:,1);
%     
%     transform = hand_bbox_cam2./hand_bbox_cam1;
%     
%     
%     all_bboxes_cam2 = all_bboxes .* repmat(transform, 1,size(all_bboxes,2)); 
%     
    
    
    
    
    
    %% visualize all bboxes
    for j=1:20:600
        
        imshow(all_images{j});
        
        bbox = all_bboxes(:,j);
        
        rectangle('Position',[bbox(1) bbox(2) (bbox(3)-bbox(1)) (bbox(4)-bbox(2))], 'LineWidth',2, 'EdgeColor','b');
        
        
        [x y but]  =ginput(1);
        
        if(but ~= 1)
            break;
        end
    end%for j, all bboxes
    
    
        
        
    
    ground_truth_bboxes = all_bboxes;
    save(fullfile(object_path,GROUND_TRUTH_BBOXES_DIR,'ground_truth_bboxes.mat'),'ground_truth_bboxes');
    
    
end%for i, each object name







