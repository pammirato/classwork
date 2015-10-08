function [dbeta0,dbeta] = dAverageLogLikLogReg(y,X,beta0,beta,lambda)
    prob =  ones(length(y),1) ./ (1 + exp(-y.*(beta0 + beta*x')'));
    
    N = 1/ length(y);
    
    dbeta0 =(1/N) * sum(((1-prob).*y)');
    
    dbeta =(1/N) * ((1-prob).*y)' * X;
    
    
end

