

init;



object_name = 'all';  %make this = 'all' to go through all rooms


load_data = 0;

desired_num_test_images_per_object = 10;



%% load all data



if(load_data)






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
test_true_labels = cell(0);

for i=1:num_objects
    
    if(num_objects >1)
        object_name = d(i).name()
    end
    
    object_path = fullfile(BASE_PATH,object_name);

    cur_test_sift = load(fullfile(object_path,'test_sift.mat'));

    
    test_frames = cat(2,test_frames, cur_test_sift.test_frames);
    test_descriptors = cat(2,test_descriptors, cur_test_sift.test_descriptors);
    test_true_labels = cat(2,test_true_labels,repmat({object_name},1,length(cur_test_sift.test_frames)));
    
end





%% reduce amount of data

total_num_test_frames_per_object = length(test_frames)/num_objects;

index_skip = total_num_test_frames_per_object  / desired_num_test_images_per_object;

test_frames = test_frames(1:index_skip:end);
test_descriptors = test_descriptors(1:index_skip:end);
test_true_labels = test_true_labels(1:index_skip:end);

end%if load_data


%% now run the experiment
% 
% indices = [1:60:120  381:60:500]
% 
% [ref_frames,ref_descriptors,ref_labels] = get_reference_features({'all'},indices,true);
% 
% test_predicted_labels = sift_matching(ref_frames,ref_descriptors,ref_labels,test_frames,test_descriptors);



%% convert labels to numbers
% 
label_names = {d.name};
label_indices = [1:length(label_names)];

name_to_index_map = containers.Map(label_names,label_indices);


for i =1:length(test_predicted_labels)
      
        index1 = name_to_index_map(test_predicted_labels{i});
        test_predicted_labels{i} = index1;
        if(load_data)
            index2 = name_to_index_map(test_true_labels{i});
            test_true_labels{i} = index2;
        end
end
if(load_data)
    test_true_labels = cell2mat(test_true_labels);
end
test_predicted_labels = cell2mat(test_predicted_labels);
 
%%  evaluate 


label_diff = abs(test_predicted_labels - test_true_labels);
label_diff(label_diff>0) = 1;

correct_rate = length(find(label_diff == 0))/length(test_true_labels);

num_correct_per_object = zeros(1,num_objects);


for i=1:length(num_correct_per_object)
    
    start_index = (i-1)*desired_num_test_images_per_object +1;
    end_index = (i-1)*desired_num_test_images_per_object + desired_num_test_images_per_object;
    
    cur_label_diff = label_diff((start_index:end_index));
    

    num_correct_per_object(i) = length(find(cur_label_diff == 0));
end


plot(1:num_objects,num_correct_per_object,'r.','MarkerSize',10);
    
    
    




    
    