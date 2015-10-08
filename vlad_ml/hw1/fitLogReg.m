function [beta0,beta] = fitLogReg(trainY,trainX,lambda,s)

    %initialization of betas  - random
    scale = 100;
    beta0 = randn(1)/scale;
    beta = randn(1,size(trainX,2))/scale;
    
    
    %set a threshold for convergence
    convergence_thresh = 1e-1;
    
    %a safety net for testing.
    max_iter = 1000;
    cur_iter = 0;
    
    %set a step size for gradient descent
    %step_size = 1e-1;
    
    
    %compute the inital loglikelyhood
    prev_ll = AverageLogLikLogReg(trainY,trainX,beta0,beta,lambda);
    
    %keeps track of how much we are improving our solution
    improvement = convergence_thresh *2; %make it over the thresh to start
    
    while((improvement > convergence_thresh) && (cur_iter < max_iter))
        
        %get gradients
        [dBeta0, dBeta] = dAverageLogLikLogReg(trainY,trainX,beta0,beta,lambda); 
        
        %move a step in gradient direction
        beta0 = beta0 + s*dBeta0;
        beta  = beta  + s*beta;
        
        
        cur_ll = AverageLogLikLogReg(trainY,trainX,beta0,beta,lambda);
        
        improvement = cur_ll - prev_ll;
        prev_ll = cur_ll;
        
        cur_iter = cur_iter +1;
    end%while improv < conv
    
    cur_iter
end
    