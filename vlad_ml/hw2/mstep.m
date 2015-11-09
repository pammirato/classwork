function theta = mstep(q,X,theta)
    A = size(theta,1); % size of alphabet
    L = size(theta,2); % length of motif
    N = size(X,2);     % length of full sequence
    T = size(X,3);     % number of examples
    assert(size(q,1) == N-L+1 && size(q,2) == T);
    for t=1:T
        for h=1:N-L+1
            theta = theta + X(:,h:h+L-1,t) * (q(h,t)/-A);
        end
    end

    for i=1:L
        theta(:,i) = theta(:,i) / sum(theta(:,i));
    end
end