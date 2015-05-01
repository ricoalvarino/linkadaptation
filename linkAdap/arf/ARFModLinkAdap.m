classdef ARFModLinkAdap < LinkAdap
    %ARFMODLinkAdap Implements ARF_M with MCS increment
    
    properties
        currentCount        %Count of current MCS
        deltaUp
        deltaDown        
    end
    
    methods
        function o = ARFModLinkAdap(mcsSet,targetPER,deltaUp)
           o = o@LinkAdap(mcsSet);
           o.deltaUp = deltaUp;
           o.deltaDown = (1/targetPER - 1)*deltaUp;
           o.currentCount = 0;
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            if fb.success == 0      %NAK
                this.currentCount = this.currentCount - this.deltaDown;
            else
                this.currentCount = this.currentCount + this.deltaUp;
            end
            addLog(this,this.currentCount);
        end
        
        function mcs = getMCS(this)
           if this.currentCount < 1
               mcs = 1;
           elseif this.currentCount > length(this.mcsSet)
               mcs = length(this.mcsSet);
           else
               mcs = floor(this.currentCount);               
           end
        end
        
        function init(this)
           this.currentCount = 0;
        end
    end
    
end

