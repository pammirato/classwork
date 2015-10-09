function [dbeta0,dbeta] = dAverageLogLikLogReg(y,X,beta0,beta,lambda)
    prob =  ones(length(y),1) ./ (1 + exp(-y.*(beta0 + beta*X')'));
    
    N = length(y);
    
    dbeta0 =((1/N) * sum(((1-prob).*y)'));
    
    dbeta =(((1/N) * ((1-prob).*y)' * X)  - 2*lambda*beta);   
end

