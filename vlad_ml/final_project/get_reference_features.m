


function [ref_frames, ref_descriptors,ref_labels] = get_reference_features(object_names, indices)

    init;


    if(strcmp(object_names{1},'all'))
        
        d = dir(BASE_PATH);
        d = d(3:end);
        
        object_names = {d.name};
    end
   
    num_objects = length(object_names);

    n = length(indices);
    
    ref_frames = cell(1,num_objects*n);
    ref_descriptors = cell(1,num_objects*n);
    ref_labels = cell(1,num_objects*n);
    
    for i=1:num_objects

        object_name = d(i).name();
        object_path = fullfile(BASE_PATH,object_name);

        train_names = load(fullfile(object_path,TRAIN_TEST_NAMES_FILE));
        train_names = train_names.train_names;
        
        
        for j=1:n
            
            file_name = train_names{indices(j)};
            
            features = load(fullfile(object_path,strcat(file_name(1:end-4),'_sift.mat')));
        
            ref_frames{(i-1)*n +j} = features.frames;
            ref_descriptors{(i-1)*n +j} = features.descriptors;
            ref_labels{(i-1)*n +j} = object_name;

        end

    end
    
    
    
end%function get_reference_features