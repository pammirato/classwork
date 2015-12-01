% k = 5;
% T = 10;
% y = 3*ones(3,3);
% xi = @(v,i,j) (v - y(i,j)).^2;
% theta = @(a,b) (a-b).^2;
% p = conditional(y,2,2,theta,xi,T,k)

y = load('hw3.mat');
y = y.y;

all_energies = cell(1,5);
for i=1:5


    k = max(max(y));
    T = 5;
    xi = @(v,i,j) (v - y(i,j)).^2;
    theta = @(a,b) (a-b).^2;
    % xi = @(v,i,j) 2*(v - y(i,j)).^2;
    % theta = @(a,b) 1/4*(a-b).^2;
    [best_x, mean_x, mean_x_after_B,energies] = gibbs(theta,xi,T,k,y,i);
    
    all_energies{i} = energies;
end