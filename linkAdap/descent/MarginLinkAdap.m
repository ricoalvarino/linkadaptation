classdef MarginLinkAdap < LinkAdap
    %MarginLinkAdap Implements link adaptation with variable margin
    %depending on ACK/NAK information
    
    properties
        mu
        p0
        currentOffset
        snrThreshold
    end
    
    methods
        function o = MarginLinkAdap(mcsSet,targetPER,mu)
           o = o@LinkAdap(mcsSet);
           %Initialize parameters
            o.mu = mu;
            o.p0 = targetPER;
           o.currentOffset = 0;
           %Initialize SNR thresholds - in dB
           o.snrThreshold = zeros(length(mcsSet)-1,1);
           for in=1:length(o.snrThreshold)
              o.snrThreshold(in) = 10*log10(MICalculator.calcSNR(mcsSet(in+1).rate,mcsSet(in+1).modulation)); 
           end
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            
            this.currentOffset = this.currentOffset - this.mu*((1-fb.success) - this.p0);
          
            addLog(this,this.currentOffset)
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
            %The total SNR is the received by feedback plus the margin.
            snrTot = 10*log10(MICalculator.calcSNR(this.mcsSet(lastCQI).rate,this.mcsSet(lastCQI).modulation)) + this.currentOffset;
            for in=1:length(this.snrThreshold)
                if snrTot >= this.snrThreshold(in)
                    mcs = mcs+1;
                end
            end
        end
        
        function init(this)
            this.currentOffset = 0;
        end
    end
    
end

