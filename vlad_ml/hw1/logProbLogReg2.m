function logP = logProbLogReg2(y,x,beta0,beta)
    logP = ones(length(y),1) ./ (1 + exp(-y.*(beta0 + beta*x')'));
end