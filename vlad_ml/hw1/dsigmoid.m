function d = dsigmoid(z)
    % This function computes first derivative of sigmoid function at z
    d =- exp(z) / (exp(z) +1)^2;
end