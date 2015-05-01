classdef LMS2OuterLinkAdap < LinkAdap
    %LMS2OuterLinkAdap Implements link adaptation with variable margin
    %depending on ACK/NAK information
    
    properties
        deltaUp
        deltaDown
        currentOffset
        
        %Variables for outer outer loop
        xiUp
        xiDown
        
        snrThreshold
        currentScaling
        lastCqi
        muOuterOuter
    end
    
    methods
        function o = LMS2OuterLinkAdap(mcsSet,targetPER,deltaUp)
           o = o@LinkAdap(mcsSet);
           %Initialize parameters
           o.deltaUp = deltaUp;
           o.deltaDown = (1/targetPER - 1)*deltaUp;
           
           o.xiUp = o.deltaUp;
           o.xiDown = o.deltaDown;
           
           o.currentOffset = 0;
           %Initialize SNR thresholds - in dB
           o.snrThreshold = zeros(length(mcsSet)-1,1);
           for in=1:length(o.snrThreshold)
              o.snrThreshold(in) = 10*log10(MICalculator.calcSNR(mcsSet(in+1).rate,mcsSet(in+1).modulation)); 
           end
           o.currentScaling = 1;
           o.lastCqi = [];
           o.muOuterOuter = 0.01;         
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            
            this.lastCqi = fb.param.memoryLinkAdap;
             if ~isempty(this.lastCqi)
                 
                 %Update deltaDown
                 if fb.success == 0
                    this.deltaDown = this.deltaDown  + this.muOuterOuter*this.xiDown;
                 else
                     this.deltaDown = this.deltaDown  - this.muOuterOuter*this.xiUp;
                 end
                 
                if fb.success == 0      %NAK
                    err = -this.deltaDown;
                else
                    err = this.deltaUp;
                end
                normalization = 0.1/(this.lastCqi^2 + 1);
                this.currentOffset = this.currentOffset + normalization*err;
                this.currentScaling = this.currentScaling + normalization*err*this.lastCqi;
             end
                addLog(this,[this.currentOffset; this.currentScaling; this.deltaDown]);
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
            %Save parameter (for adaptation with delay)
            param.memoryLinkAdap = this.lastCqi;
        end
        
        function init(this)
            this.currentOffset = 0;
        end
    end
    
end

