classdef DelayFeedback < handle
    %DELAY Implements a delay
    
    properties
        queue@Feedback
    end
    
    methods
        function o = DelayFeedback(num)
            if num > 0
                o.queue(num) = Feedback();
            end
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

