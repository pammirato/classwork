function new = sample(x,i,j,theta,xi,T,k)
    p = conditional(x,i,j,theta,xi,T,k);
    new = samplediscrete(p,1);
    %[~,new] = max(p);  
end



function s = samplediscrete(ps,T)
    cdf = cumsum( ps );
    s = zeros(T,1);
    
    for t=1:T
         r = rand(1,1);
         s(t) = find( r <cdf , 1);
    end
end
