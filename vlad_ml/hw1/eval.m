function num_error = eval(Y,X,beta0,beta);


    guess = [ones(size(X,1),1) X] * [beta0 beta]';
    
    diff = Y - sign(guess);
    
    num_error = sum(diff)/2;



end%eval