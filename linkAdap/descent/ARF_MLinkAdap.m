classdef ARF_MLinkAdap < MarginLinkAdap
    %ARF_MLinkAdap Modification of MarginLinkAdap that neglects the CQI
    %feedback
    
    
    methods
        function o = ARF_MLinkAdap(mcsSet,targetPER,mu)
           o = o@MarginLinkAdap(mcsSet,targetPER,mu);
        end
        
        
        function mcs = getMCS(this,param)
            mcs = 1;
            %The total SNR is the received by feedback plus the margin.
            snrTot = this.currentOffset;
            for in=1:length(this.snrThreshold)
                if snrTot >= this.snrThreshold(in)
                    mcs = mcs+1;
                end
            end
        end
        
    end
    
end

