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
    
    all_bboxes = load(fullfile(bbox_path,'ground_truth_bboxes.mat'));
    all_bboxes = all_bboxes.ground_truth_bboxes;
    
    
    dd = dir(fullfile(object_path,'*.jpg'));
    full_image_names = {dd.name};
    
    ground_truth_bboxes = zeros(4,length(full_image_names));
    
    for j=1:length(full_image_names)
        
        cur_full_image_name = full_image_names{j};
        full_img = imread(fullfile(object_path,cur_full_image_name));
        
        bbox = all_bboxes(:,j);

        bbox_img = full_img(bbox(2):bbox(4), bbox(1):bbox(3),:);
        
        [frames, descriptors] = getFeatures(bbox_img,'peakThreshold', 0.01);
        
        imwrite(bbox_img,fullfile(bbox_path,strcat('bb_', cur_full_image_name)));
        
        save(fullfile(bbox_path,strcat('bb_',cur_full_image_name(1:end-4),'_sift.mat')), 'frames', 'descriptors');
        
    end% for j
    

end