classdef StatsAvgTput < Stats
    %STATSAVGTPUT Basic statistic gathering. Average throughput is
    %calculated as a plain average
        methods
            
        function o = StatsAvgTput()
           o = o@Stats();
        end
        
        function add(this, curRate,success)
            if success == 1 
                this.numPacketsOK = this.numPacketsOK + 1;
            else
                this.numPacketsNOK = this.numPacketsNOK + 1;
            end
            totalPackets = this.numPacketsNOK + this.numPacketsOK;
            
            this.rate = this.rate*(totalPackets-1)/totalPackets + curRate/totalPackets;
            this.tput = this.tput*(totalPackets-1)/totalPackets + curRate*success/totalPackets;   
            
            %Add to series
            if this.saveSeries == 1
                this.seriesRate = [this.seriesRate, curRate];
                this.seriesOK = [this.seriesOK, success];
            end
        end
        
    end
    
end

