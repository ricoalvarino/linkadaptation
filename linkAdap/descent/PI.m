classdef PI < LinkAdap
    %PI
    %
    %Implements adaptation based on a PI controller. The
    %adaptation is
    % lambda_{i+1} = lambda_i + beta*(e_i-p_0)
    % c_{i+1} = c_i + lambda_{i+1} + mu*(e_i-p_0)
    
    properties
        currentCount        %Count of current MCS   
        muLambda
        lambda
        r
        targetPER
        muP
    end
    
    methods
        function o = PI(mcsSet,targetPER,mu)
           o = o@LinkAdap(mcsSet);
           o.targetPER = targetPER;
           o.lambda = 0;
           o.r = 0;
           
           %Adaptation steps
           o.muLambda = mu/10;
           o.muP = mu;
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            error = 1-fb.success;
            
            %Update r
            this.lambda = this.lambda - this.muLambda*(error - this.targetPER);
            this.r = this.r + this.lambda - this.muP*(error - this.targetPER);
            
            
            addLog(this,[this.r, this.lambda]);
        end
        
        function mcs = getMCS(this,param)
           if this.r < 1
               mcs = 1;
           elseif this.r > length(this.mcsSet)
               mcs = length(this.mcsSet);
           else
               mcs = floor(this.r);               
           end
        end
        
        function init(this)
           this.currentCount = 0;
        end
    end
    
end

