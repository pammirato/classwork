init;



object_name = 'all';  %make this = 'all' to go through all rooms

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
    
    masks_path = fullfile(object_path,'masks');
    
    
    dd = dir(fullfile(masks_path,'*.pbm'));
    mask_names = {dd.name};
    
    ground_truth_bboxes = zeros(4,length(mask_names));
    
    for j=1:length(mask_names)
        
        cur_mask_name = mask_names{j};
        mask_img = imread(fullfile(masks_path,cur_mask_name));
        
        [I, J] = find(mask_img == 0);
        
        ground_truth_bboxes(:,j) = [min(J) min(I) max(J) max(I)]';
        
        
    end% for j
    
    save(fullfile(object_path,GROUND_TRUTH_BBOXES_DIR,'ground_truth_bboxes.mat'),'ground_truth_bboxes','mask_names');
end