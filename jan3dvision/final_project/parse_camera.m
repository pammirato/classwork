base_path = fullfile('./all_data/');

d = dir(base_path);
d= d(3:end);


K = eye(3,3);
R = eye(3,3);
C = zeros(1,3);

all_camera_data = zeros(length(d)/2, 12+9+9+3);

for i=1:2:length(d)

    P = load(fullfile(base_path,d(i).name));
    
    i = i+1;
    
    

    fid = fopen(fullfile(base_path,d(i).name),'rt');
    

    line1 = strsplit(fgets(fid));
    line2 = strsplit(fgets(fid));
    line3 = strsplit(fgets(fid));

    K(1,:) = str2double(line1(1:3));
    K(2,:) = str2double(line2(1:3));
    K(3,:) = str2double(line3(1:3));

    line1 = strsplit(fgets(fid));%line of 0s
    line1 = strsplit(fgets(fid));
    line2 = strsplit(fgets(fid));
    line3 = strsplit(fgets(fid));

    R(1,:) = str2double(line1(1:3));
    R(2,:) = str2double(line2(1:3));
    R(3,:) = str2double(line3(1:3));

    line1 = strsplit(fgets(fid));
    C(1,:) = str2double(line1(1:3));
    
    
    all_camera_data(i/2,:) = [P(:)', K(:)', R(:)', C(:)'];


end