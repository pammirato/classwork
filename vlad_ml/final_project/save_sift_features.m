

init;

object_name = 'softsoap_gold';  %make this = 'all' to go through all rooms









d = dir(BASE_PATH);
d = d(3:end);

if(strcmp(object_name,'all'))
    num_objects = length(d);
else
    num_objects = 1;
end


%first get all the test data
test_frames = cell(0);
test_descriptors = cell(0);


for i=1:num_objects
    
    if(num_objects >1)
        object_name = d(i).name()
    end
    
    object_path = fullfile(BASE_PATH,object_name);
    
    dr = dir(fullfile(object_path,'*jpg'));
    
    
    all_names = {dr.name};
    
    
    for j=1:length(all_names)
        cur_name = all_names{j};
        [frames, descriptors] = getFeatures(imread(fullfile(object_path,cur_name)));
        
        save(fullfile(object_path,strcat(cur_name(1:end-4),'_sift.mat')),'frames','descriptors');
    end% j
    
end