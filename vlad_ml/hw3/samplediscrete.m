function s = samplediscrete(ps,T)
    cdf = cumsum( ps );
    s = zeros(T,1);

    for t=1:T
         r = rand(1,1);
         s(t) = find( r <cdf , 1);
    end
end

