function val = AverageLogLikLogReg2(y,X,beta0,beta,lambda)
    val = 0;
    %logP = log( 1 / (1 + exp(-y*(beta0 + beta*x'))));
    for i=1:length(y)
       val = val + logProbLogReg(y(i),X(i,:),beta0,beta);
    end
    val = val/length(y);
    val = val - (lambda * sum(beta.^2));
end