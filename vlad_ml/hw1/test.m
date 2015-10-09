
%for i=1:size(trainX,1)
 %   imagesc(reshape(trainX(i,:),[192 168]));colormap(gray)
  %  label = trainy(i)
   % k = input('input: ');
%end
 

imagesc(reshape(abs(beta),[192 168]));colormap(gray)

figure;
imagesc(reshape(trainX(1,:),[192 168]));colormap(gray)