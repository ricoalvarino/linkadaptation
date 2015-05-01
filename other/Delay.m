classdef Delay < handle
    %DELAY Implements a delay
    
    properties
        queue
    end
    
    methods
        function o = Delay(num)
             o.queue = zeros(1,num);
        end
        
        function push(this,newVal)
           this.queue = [this.queue, newVal]; 
        end
        
        function v = pop(this)
           v = this.queue(1);
           this.queue = this.queue(2:end);
        end
    end
    
end

