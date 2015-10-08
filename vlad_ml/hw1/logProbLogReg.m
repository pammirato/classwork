function logP = logProbLogReg(y,x,beta0,beta)
    logP = log( 1 / (1 + exp(-y*(beta0 + beta*x'))));
end