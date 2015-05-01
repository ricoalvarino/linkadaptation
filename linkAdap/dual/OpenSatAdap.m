classdef OpenSatAdap < DualLinkAdap
    %Close loop link adaptation
    properties
        %Parameters for LA
        a0
        a1
        a2
        %Current values
        curSNRcl
        curSNRol
        %Target PER
        targetPER
        p0
        %Adaptation step
        mu 
        mup
        %SNR thresholds (LUT)
        snrThreshold
    end
    
    methods
        function o = OpenSatAdap(mcsSet,targetPER)
            o = o@DualLinkAdap(mcsSet);
            o.targetPER = targetPER;
            o.init();
            o.mu = 0.01;
            o.p0 = targetPER;
           %Initialize SNR thresholds - in dB
           o.snrThreshold = zeros(length(mcsSet)-1,1);
           for in=1:length(o.snrThreshold)
              o.snrThreshold(in) = 10*log10(MICalculator.calcSNR(mcsSet(in+1).rate,mcsSet(in+1).modulation)); 
           end
        end
           
        
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
                       
            %Update coefficients
            error = 1-fb.success;
            norm = 1;
            this.a0 = this.a0 - this.mu/norm*(error - this.targetPER);

            lastCQI = fb.CQI;
            if lastCQI == 0
                lastCQI = 1;
            end

            this.curSNRcl = 10*log10(MICalculator.calcSNR(this.mcsSet(lastCQI).rate,this.mcsSet(lastCQI).modulation));
            addLog(this,[this.a0;]);
        end
        
        %Call observeChannel after addFeedback!!!
        function observeChannel(this,chanMI,param)
            %We receive in chan the value of MI. We map back to SNR
            this.curSNRol = 10*log10(MICalculator.calcSNR(chanMI,param.mcsObj.modulation));
        end
        
        function mcs = getMCS(this,param)
            snrTot = this.a0 + this.curSNRol;
            mcs = 1;
            for in=1:length(this.snrThreshold)
                if snrTot >= this.snrThreshold(in)
                    mcs = mcs+1;
                end
            end
            param.memoryLinkAdap = [this.curSNRcl, this.curSNRol];
        end
        
        function init(this)
            this.a0 = 0;
        end
    end
    
end

