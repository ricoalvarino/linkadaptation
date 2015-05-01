classdef ARFLinkAdap < LinkAdap
    %ARFLinkAdap Implements auto-rate fallback
    
    properties
        numberACKUp         %Number of consecutive ACK to go UP
        currentMCS          %Current MCS
        currentACKCount     %Number of consecutive ACK received up to now
    end
    
    methods
        function o = ARFLinkAdap(mcsSet,targetPER)
           o = o@LinkAdap(mcsSet);
           o.numberACKUp = ceil(1/(targetPER));
           o.currentMCS = 1;
           o.currentACKCount = 0;
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            if fb.success == 0      %NAK
                this.currentACKCount = 0;
                if this.currentMCS ~= 1
                    this.currentMCS = this.currentMCS - 1;
                end
            elseif fb.success == 1  %ACK
                this.currentACKCount = this.currentACKCount + 1;
                if this.currentACKCount == this.numberACKUp
                   this.currentACKCount = 0;
                   if this.currentMCS < length(this.mcsSet)
                       this.currentMCS = this.currentMCS + 1;
                   end
                end
            else
                error('Incorrect value of success in feedback');
            end
            
        end
        
        function mcs = getMCS(this,param)
            mcs = this.currentMCS;
        end
        
        function init(this)
            this.currentMCS = 1;
            this.currentACKCount = 0;
        end
    end
    
end

