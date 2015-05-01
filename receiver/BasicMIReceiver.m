classdef BasicMIReceiver < MIReceiver
    %BasicMIReceiver: Basic receiver that applies a threshold to the received MI
    
    properties
        lastParam
        lastSuccess
        lastMI
    end
    
    methods
        function o = BasicMIReceiver(mcsSet)
           o = o@MIReceiver(mcsSet);
        end
        
        function init(this)
            this.lastParam = [];
            this.lastSuccess = [];
        end
        
        function decode(this,outChannel,param)
           %Just threshold
            if this.mcsSet(param.mcs).rate > outChannel
                this.lastSuccess = 0;
            else
                this.lastSuccess = 1;
            end
            this.lastMI = outChannel;
            param.success = this.lastSuccess;
            this.lastParam = param;
            this.stats.add(this.mcsSet(param.mcs).rate, this.lastSuccess);
        end
        
        function fb = getFeedback(this)
            cqi = MICalculator.calcCQI(this.mcsSet,MICalculator.calcSNR(this.lastMI,this.lastParam.mcsObj.modulation));
            fb = Feedback(this.lastParam,cqi,this.lastSuccess);
        end
        
    end
    
end

