load hw1.mat;

stepsizes = 10.^[-1 -2 -3 -4 -5];
lambdas = [0.001 0.01 0.1 0.2 0.4 0.8 1.0];

beta0s = zeros(length(stepsizes),length(lambdas));
betas = cell(length(stepsizes),length(lambdas));


for i=1:length(stepsizes)
    for j=1:length(lambdas)
      [beta0s(i,j) betas{i,j}] = fitLogReg(trainy,trainX,lambdas(j),stepsizes(i));
    end
end

errors = zeros(size(beta0s,1),size(beta0s,2));
for i=1:size(beta0s,1)
    for j=1:size(beta0s,2)
    
        guess = [ones(size(validX,1),1) validX] * [beta0s(i,j) betas{i,j}]';

        diff = validy - sign(guess);

        num_wrong = sum(abs(diff))/2;

        errors(i,j) = num_wrong/length(validy);
    end
end

