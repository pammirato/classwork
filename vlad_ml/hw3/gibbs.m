function [best_x, mean_x, mean_x_after_B, energies] = gibbs(theta,xi,T,k,y,fignum)
    % initialize x with noisy image
    %x = y;
    x = rand(size(y));
    
    MAXIT = 15;
    B = floor(MAXIT/10);
    energies = zeros(1,MAXIT);    
    best_x = zeros(size(x)); 
    mean_x = zeros(size(x));
    mean_x_after_B = mean_x;
    lowest_energy = Inf; 
    
    % experiment with different iteration number
    for it=1:MAXIT
        for i=1:size(x,1)
            for j=1:size(x,2)
                x(i,j) = sample(x,i,j,theta,xi,T,k);
            end
        end
        figure(fignum);
        subplot(2,1,1);
        imagesc(x)
        %imshow(x./255);
        energies(it) = energy(theta,xi,T,x);
        
        
        %store best x
        if(energies(it) < lowest_energy)
            lowest_energy = energies(it);
            best_x = x;
        end
        
        %compute mean x
        mean_x = (mean_x * (it-1) + x)/it;
        
        
        %compute mean after burn in
        if(it > B)
            num = it-B;
            mean_x_after_B = (mean_x_after_B* (num-1) + x)/num;
        end
        
        
        subplot(2,1,2)
        plot(energies(5:it));
        drawnow
    end
end