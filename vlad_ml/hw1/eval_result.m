guess = [ones(size(testX,1),1) testX] * [beta0s(4,1) betas{4,1}]';

        diff = testy - sign(guess);

        num_wrong = sum(abs(diff))/2;

       test_error= num_wrong/length(validy)