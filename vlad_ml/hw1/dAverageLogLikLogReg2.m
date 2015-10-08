function [dbeta0,dbeta] = dAverageLogLikLogReg(y,X,beta0,beta,lambda)
    aLL = AverageLogLikLogReg(y,X,beta0,beta,lambda);
    
    dbeta0 = sum( (1-aLL)*y );
    
    dbeta = ((1-aLL)*y)' * X;
    
    
end

