
d = dir('./segmentation/');
d = d(3:end);



locality_coef = 1;

img  = imread(fullfile('./segmentation',d(6).name));


img = img(1:4:end,1:4:end,:);


imshow(img);


pts_clicked = zeros(1,3);


done = 0;

counter = 1;

while(~done)
    
    [x y but] = ginput(1);
    
    
    if(but ~=1)
        done = 1;
        break;
    end
    
    pts_clicked(counter, :) = [floor(x) floor(y) (x-1)*size(img,1)+y];
    counter = counter +1;
    
    
    
    
    
    
    
    
end%while

obj_x = pts_clicked(1,1);
obj_y = pts_clicked(1,2);

k = size(pts_clicked,1);
means = zeros(1,4); 



img2 = double(reshape(img,size(img,1)*size(img,2),3));
%img2(:,4) = 1:length(img2);
%img2(:,4) = (img2(:,4)/length(img2))  * 255;

% img2(:,4) = repmat(1:size(img,2),1,size(img,1));
% img2(:,4) = img2(:,4)*255/size(img,2);
% 
% img2(:,5) = repmat(1:size(img,1),1,size(img,2));
% img2(:,5) = img2(:,5)*255/size(img,1);


ys = repmat(1:size(img,2),size(img,1),1);
ys = reshape(ys,1,size(img,1)*size(img,2));

% img2(:,4) = img2(:,4)*255/size(img,2);
% 
xs = repmat(1:size(img,1),1,size(img,2));
xs = reshape(xs,1,size(img,1)*size(img,2));
% img2(:,5) = img2(:,5)*255/size(img,1);

dists = sqrt((ys-obj_x).^2 + (xs-obj_y).^2);

img2(:,4) = locality_coef*dists*255/max(dists);
%img2(:,5) = img2(:,4);



max_dist = max(dists);

for i=1:k
  means(i,1:3) = img(pts_clicked(i,2), pts_clicked(i,1),:);
  %means(i,4) = (pts_clicked(i,3)/ length(img2)) * 255;
  
%   means(i,4) = pts_clicked(i,2)*255/size(img,2);
%   means(i,5) = pts_clicked(i,1)*255/size(img,1);

    means(i,4) = locality_coef*sqrt((pts_clicked(i,1)-obj_x)^2 ...
                         + (pts_clicked(i,2)-obj_y)^2)*255/max_dist;
   % means(i,5) = sqrt(pts_clicked(i,1)^2 + pts_clicked(i,2)^2);
end





[classes,new_means] = phil_kmeans2(img2,k,means);



% classes2 = reshape(classes,size(img,1),size(img,2));
% 
% imagesc(classes2);

a = classes;
a(a~=1) = 0;
imgb = zeros(size(img2,1),3);
imgb(find(a),:) = img2(find(a),1:3);

imgc = reshape(imgb,size(img,1),size(img,2),3);

figure, imagesc(imgc./255);



while 1
    
    [x y but] = ginput(1);
    
    if(but~=1)
        break;
    end


    classes3 = classes;
    classes3(classes3 ~=1) = 0;

    img3 = img2;

    ii = find(classes3 == 0);

    %zero out stuff not from our class
    img3(ii,:) = zeros(length(ii),size(img3,2));

    % m_dist = mean(img3(:,4));
    % d_diffs = img3(:,4) - m_dist;
    % sq_diffs = (d_diffs).^2;
    % std_dev = sqrt(mean(sq_diffs));
    % 
    % d_diffs(abs(d_diffs) > 2*std_dev) = -123456;
    % 

    % kk = find(d_diffs == -123456);
    % img3(kk,:) = zeros(length(kk),size(img3,2));



    [a,b] = max(img3(:,4));

    img3(ii,:) = 9999*ones(length(ii),size(img3,2));
    img3(:,4) = img2(:,4);
    [a,bb] = max(img3(ii,4));




    %pick new means
    means = means(1,:);
    means(2,:) = img3(b,:);
    means(3,:) = img3(bb,:);

    locality_coef = 2;

    img3(:,4) = img3(:,4)*locality_coef;
    means(:,4) = means(:,4)*locality_coef;

    [classes,new_means] = phil_kmeans2(img3,3,means);


    classes2 = reshape(classes,size(img,1),size(img,2));

    %figure,imagesc(classes2);
    
    a = classes;
    a(a~=1) = 0;
    imgb = zeros(size(img3,1),3);
    imgb(find(a),:) = img3(find(a),1:3);
    
    imgc = reshape(imgb,size(img,1),size(img,2),3);
    
    figure, imagesc(imgc./255);


end





while 1
    
    [x y but] = ginput(1);
    
    if(but~=1)
        break;
    end


    classes3 = classes;
    classes3(classes3 ~=1) = 0;

    img3 = img2;

    ii = find(classes3 == 0);

    %zero out stuff not from our class
    img3(ii,:) = zeros(length(ii),size(img3,2));

    % m_dist = mean(img3(:,4));
    % d_diffs = img3(:,4) - m_dist;
    % sq_diffs = (d_diffs).^2;
    % std_dev = sqrt(mean(sq_diffs));
    % 
    % d_diffs(abs(d_diffs) > 2*std_dev) = -123456;
    % 

    % kk = find(d_diffs == -123456);
    % img3(kk,:) = zeros(length(kk),size(img3,2));



    [a,b] = max(img3(:,4));

    img3(ii,:) = 9999*ones(length(ii),size(img3,2));
    img3(:,4) = img2(:,4);
    [a,bb] = max(img3(ii,4));




    %pick new means
    means = means(1,:);
    means(2,:) = img3(b,:);
    means(3,:) = img3(bb,:);

    locality_coef = 0;

    img3(:,4) = img3(:,4)*locality_coef;
    means(:,4) = means(:,4)*locality_coef;

    [classes,new_means] = phil_kmeans2(img3,3,means);


    classes2 = reshape(classes,size(img,1),size(img,2));

    %figure,imagesc(classes2);
    
    a = classes;
    a(a~=1) = 0;
    imgb = zeros(size(img3,1),3);
    imgb(find(a),:) = img3(find(a),1:3);
    
    imgc = reshape(imgb,size(img,1),size(img,2),3);
    
    figure, imagesc(imgc./255);


end

% 
% img3 = img2(:,1:3);
% 
% img3(find(classes),:) = [0 0 0];
% 
% img3 = reshape(img3,size(img,1),size(img,2),3);
% 
% imagesc(img3./255);


