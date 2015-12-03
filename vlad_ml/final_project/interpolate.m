function values = interpolate(start_val,end_val,num)
        
        diff = end_val - start_val;
        step_size = diff/num;
        
        if(step_size == 0)
            values = start_val*ones(1,num+1);
        else
            values = start_val:step_size:end_val;
        end
        
end