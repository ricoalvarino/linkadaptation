classdef DualSatAdap < DualLinkAdap
    %DualSatAdap Algorithm that performs adaptation in the RL of LMS
    %channel using information of both RL (delayed) and FL (possibly
    %uncorrelated)
    %Adaptation is performed via LUT: a_0 + a_1*SNR_f + a_2*SNR_ol 
    %
    %With SNR_f the snr from feedback (in dB) and SNR_ol the SNR observed
    %in the OL
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
        function o = DualSatAdap(mcsSet,targetPER)
            o = o@DualLinkAdap(mcsSet);
            o.targetPER = targetPER;
            o.init();
            o.mu = 1;
            o.p0 = targetPER;
            o.mup = 0.001;
           %Initialize SNR thresholds - in dB
           o.snrThreshold = zeros(length(mcsSet)-1,1);
           for in=1:length(o.snrThreshold)
              o.snrThreshold(in) = 10*log10(MICalculator.calcSNR(mcsSet(in+1).rate,mcsSet(in+1).modulation)); 
           end
        end
           
        
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);
            
            %Get info from feedback
            fbSNRcl = fb.param.memoryLinkAdap(1);
            fbSNRol = fb.param.memoryLinkAdap(2);
            
            %Update coefficients
            error = 1-fb.success;
            norm = (10^2+fbSNRcl^2+fbSNRol^2);
            this.a0 = this.a0 - 10*this.mu/norm*(error - this.p0);
            this.a1 = this.a1 - this.mu/norm*(error-this.p0)*fbSNRcl;
            this.a2 = this.a2 - this.mu/norm*(error-this.p0)*fbSNRol; 
            lastCQI = fb.CQI;
            this.p0 = this.p0 - this.mup*(error-this.targetPER);
            if lastCQI == 0
                lastCQI = 1;
            end
            this.curSNRcl = 10*log10(MICalculator.calcSNR(this.mcsSet(lastCQI).rate,this.mcsSet(lastCQI).modulation));
            addLog(this,[this.a0; this.a1; this.a2;]);
        end
        
        %Call observeChannel after addFeedback!!!
        function observeChannel(this,chanMI,param)
            %We receive in chan the value of MI. We map back to SNR
            this.curSNRol = 10*log10(MICalculator.calcSNR(chanMI,param.mcsObj.modulation));
        end
        
        function mcs = getMCS(this,param)
            snrTot = this.a0 + this.a1*this.curSNRcl + this.a2*this.curSNRol;
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
            this.a1 = .5;
            this.a2 = .5;
            this.curSNRol = 0;
            this.curSNRcl = 0;
        end
    end
    
end

