function [dbeta0,dbeta] = dAverageLogLikLogReg(y,X,beta0,beta,lambda)
    dbeta0 = -y*(1 - AverageLogLikLogReg(y,X,beta0,beta,lambda));
    dbeta = zeros(length(beta));
    for i=1:length(beta)
        i
        yx = -y'*X(:,i);
        N = length(y);
        ridge_penalty = -2*lambda*beta(i);
        dbeta(i) = (yx * (N - AverageLogLikLogReg(y,X,beta0,beta,lambda)) )  - ridge_penalty;
        %dbeta(i) =( -y*X(:,j) )* ( length(y) - AverageLogLikLogReg(y,X,beta0,beta) );
    end
end