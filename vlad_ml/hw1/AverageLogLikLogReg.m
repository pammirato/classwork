function [val,logP] = AverageLogLikLogReg(y,X,beta0,beta,lambda)
    first = (1 + exp(-y.*(beta0 + beta*X')'));
    second = ones(length(first),1) ./ first;
    logP = log( second);
    val = sum(logP) / length(y);
    val = val - (lambda * sum(beta.^2));
end