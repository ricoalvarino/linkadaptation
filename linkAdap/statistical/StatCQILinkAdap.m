classdef StatCQILinkAdap < StatAckLinkAdap
    %StatCQILinkAdap Learns the error probability of each of the MCS by
    %observing the CQI feedback
    
    properties
    end
    
    methods
        function o = StatCQILinkAdap(mcsSet,targetPER)
           o = o@StatAckLinkAdap(mcsSet, targetPER);
           %Initialize parameters
           o.numberObservations = ones(size(mcsSet));
           o.numberErrors = targetPER*ones(size(mcsSet));
           o.targetPER = targetPER;
           
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            for in=1:length(this.numberObservations)
                 this.numberObservations(in) =  this.numberObservations(in) + 1;
            end
            for in=(fb.CQI+1):length(this.numberObservations)
               this.numberErrors(in) = this.numberErrors(in) + 1;
            end
        end
        
        function mcs = getMCS(this,param)
            mcs = 1;    
            if this.random == 0
                for in=2:length(this.numberObservations)
                   if this.numberErrors(in)/this.numberObservations(in) <= this.targetPER
                      mcs = mcs + 1; 
                   end
                end
            else
               mcs =  StatAckLinkAdap.generateDiscreteRV(this.probabilityLA(),1:length(this.numberObservations)); 
            end          
            
        end
        
        function init(this)
            this.numberObservations = ones(size(this.numberObservations));
            this.numberErrors = this.targetPER*ones(size(this.numberObservations));
        end
    end
    
end

