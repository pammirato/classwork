function y = predictY(X,beta0,beta)

%each row in X is a sample
y = zeros(1,size(X,1));

for i=1:length(y)
    logProbY = logProbLogReg(1,X(i,:),beta0,beta);
    if logProbY > log(.5)
        predY = 1;
    else
        predY = -1;
    end
    y(i) = predY;
end