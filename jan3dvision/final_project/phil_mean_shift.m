function [clusters, means] = phil_mean_shift(data,bandwidth)


   cur_cluster = 1;

   clusters(cur_cluster,:) = zeros(1,size(data,1));
   
   
   available_indices = find(sum(clusters,1)==0);
   
   while(length(available_indices) > 0)

       %init with random point as mean
           %init k means with random data points
        %init_i = randi([1 length(available_indices)],1,1);
       % cur_mean = data(available_indices( init_i),:);
       cur_mean = data(available_indices(1),:);


        while 1

            %find distance from points to this mean

            dists2 = pdist2(data,cur_mean);

            dists = dists2;

            %indicate points that are outside bandwidth
            dists(dists>bandwidth) = -1;

            %assign points within bandwith to this cluster
            clusters(cur_cluster,find(dists>=0)) = clusters(cur_cluster,find(dists>=0)) + 1;


            %calc new mean
            old_mean  = cur_mean;

            cur_mean = mean(data(find(dists>=0),:));




            if(abs(cur_mean-old_mean) < bandwidth)
                break;
            end






        end%wwhile 1
    
            
     cur_cluster = cur_cluster + 1;

    clusters(cur_cluster,:) = zeros(1,size(data,1));


     available_indices = find(sum(clusters,1)==0); 
   end
    
    
    
    
    
   clusters(end,:) = [];
    
    



 means = cur_mean;


end%