classdef StatLinkAdapGenieAided < LinkAdap
    %StatLinkAdapGenieAided -------- DEPRECATED
    
    properties
        snr
        pErr
        targetPER
        p
    end
    
    methods
        function  o = StatLinkAdapGenieAided(mcsSet,targetPER,snr)
            warning('I think this is not gonna work');
            o = o@LinkAdap(mcsSet);
           % keyboard
            o.p = zeros(size(o.mcsSet));
            %Calculate error probabilities 
            o.pErr = zeros(size(mcsSet));
            o.targetPER = targetPER;
            o.snr = snr;
            tput = o.pErr;
            for in=1:length(o.pErr)
               o.pErr(in) = 1 - exp(-(2^(mcsSet(in).rate) -1)/snr);
               tput(in) = (1-o.pErr(in))*mcsSet(in).rate;
            end
            if min(o.pErr) > 0.1
               o.p(1) = 1;    %If the problem is not feasible, we exit
            else
               options=optimset('Display', 'off');
%                keyboard
               o.p = linprog(-tput, o.pErr, o.targetPER, ones(size(tput)),1,zeros(size(o.p)),ones(size(o.p)),[],options);
            end            
            
        end
        
        
        function addFeedback(this,fb)
           %Nothing to do 
        end
        
        function mcs = getMCS(this)
           mcs = StatAckLinkAdap.generateDiscreteRV(this.p,1:length(this.p)) ;
        end
        
        function init(this)
            
        end
        
    end
    
end

