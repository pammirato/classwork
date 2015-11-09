clear all, close all;


% A = 4; L = 5; T = 300;
% mytheta = randomtheta(A,L);
% mymotifs = samplemotif(mytheta,T);
% 
% 
% lpf = logpf(mymotifs(:,:,1),mytheta);
% 
% N = 10;
% 
% [X,groundtruthh] = samplesequences(N,T,mytheta);



% A = 4;L = 5;N = 10;T = 300;
% mytheta = randomtheta(A,L);
% [X,groundtruthh] = samplesequences(N,T,mytheta);
% q = estep(mytheta,X);
% [~,besth] = max(q);
% f = sum(besth ~= groundtruthh)/T


A = 4;L = 5;N = 10;T = 300;
mytheta = randomtheta(A,L);
[X,groundtruthh] = samplesequences(N,T,mytheta);
q = estep(mytheta,X);
newtheta = mstep(q,X,mytheta);
newtheta
mytheta



% load hw2.mat;
% L=10,iterations=50;
% em(X,L,iterations);


