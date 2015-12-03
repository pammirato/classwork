

init;



object_name = 'all';  %make this = 'all' to go through all rooms



[ref_frames,ref_features] = get_reference_features({'all'},1);






d = dir(BASE_PATH);
d = d(3:end);

if(strcmp(object_name,'all'))
    num_objects = length(d);
else
    num_objects = 1;
end


%first get all the test data
%test_frames = cell(0);
%test_descriptors = cell(0);


for i=1:num_objects
    
    if(num_objects >1)
        object_name = d(i).name()
    end
    
    object_path = fullfile(BASE_PATH,object_name);

    test_names = load(fullfile(object_path,TRAIN_TEST_NAMES_FILE));
    test_names = test_names.test_names;

    test_frames = cell(1,length(test_frames));
    test_descriptors = cell(1,length(test_frames));
    
    for j=1:length(test_names)

        file_name = test_names{j};

        features = load(fullfile(object_path,strcat(file_name(1:end-4),'_sift.mat')));

        test_frames{j} = features.frames;
        test_descriptors{j} = features.descriptors;

    end
    
    
    save(fullfile(object_path,'test_sift.mat'),'test_frames','test_descriptors');
    
%     test_frames = cat(2,test_frames, cur_test_frames);
%     test_descriptors = cat(2,test_descriptors, cur_test_descriptors);
%     
    
end



    
