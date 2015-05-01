classdef LMSLinkAdap < LinkAdap
    %LMSLinkAdap Implements link adaptation with variable margin and
    %scaling depending on ACK/NAK information
    
    
    properties
        deltaUp
        deltaDown
        currentOffset
        snrThreshold
        currentScaling
        lastCqi
    end
    
    methods
        function o = LMSLinkAdap(mcsSet,targetPER,deltaUp)
           o = o@LinkAdap(mcsSet);
           %Initialize parameters
           o.deltaUp = deltaUp;
           o.deltaDown = (1/targetPER - 1)*deltaUp;
           o.currentOffset = 0;
           %Initialize SNR thresholds - in dB
           o.snrThreshold = zeros(length(mcsSet)-1,1);
           for in=1:length(o.snrThreshold)
              o.snrThreshold(in) = 10*log10(MICalculator.calcSNR(mcsSet(in+1).rate,mcsSet(in+1).modulation)); 
           end
           o.currentScaling = 1;
           o.lastCqi = [];
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            this.lastCqi = fb.param.memoryLinkAdap;
             if ~isempty(this.lastCqi)
                if fb.success == 0      %NAK
                    err = -this.deltaDown;
                else
                    err = this.deltaUp;
                end
                normalization = 1;%0.1/(this.lastCqi^2 + 1);
                this.currentOffset = this.currentOffset + normalization*err;
                this.currentScaling = this.currentScaling + normalization*err*this.lastCqi;
             end
                addLog(this,[this.currentOffset; this.currentScaling]);
        end
        
        function mcs = getMCS(this,param)
            %We geet the SNR feedback from the CQI information
            if isempty(this.lastFeedback)
                lastCQI = 0;
            else
                lastCQI = this.lastFeedback.CQI;
            end
            if lastCQI == 0
                lastCQI = 1;
            end
            mcs = 1;
            
            this.lastCqi = 10*log10(MICalculator.calcSNR(this.mcsSet(lastCQI).rate,this.mcsSet(lastCQI).modulation));
            %The total SNR is the received by feedback plus the margin.
            snrTot = this.lastCqi*this.currentScaling + this.currentOffset;
            for in=1:length(this.snrThreshold)
                if snrTot >= this.snrThreshold(in)
                    mcs = mcs+1;
                end
            end
            
            param.memoryLinkAdap = this.lastCqi;
        end
        
        function init(this)
            this.currentOffset = 0;
        end
    end
    
end

