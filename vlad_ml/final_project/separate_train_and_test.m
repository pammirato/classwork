

init;



object_name = 'softsoap_gold';  %make this = 'all' to go through all rooms






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
    
    dr = dir(fullfile(object_path,'*jpg'));
    
    
    all_names = {dr.name};
    
    test_indices = 1:6:length(all_names);
    
    test_names = all_names(test_indices);
    train_names = all_names(setdiff(1:length(all_names),test_indices));
    
    
    save(fullfile(object_path, TRAIN_TEST_NAMES_FILE),'train_names','test_names');
    
    
    
    
end