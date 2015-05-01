classdef (Abstract) Stats < handle
    %Class for statistics
    
    properties
        %Parameters for "average" generation
        rate
        tput
        numPacketsOK
        numPacketsNOK
        
        %Parameters for series generations
        saveSeries
        seriesRate
        seriesOK
    end
    
    methods
        function o = Stats()
           o.rate = 0;
           o.tput = 0;
           o.numPacketsOK = 0;
           o.numPacketsNOK = 0;
           o.seriesRate = [];
           o.seriesOK = [];
           o.saveSeries = 1;
        end
        
        function r = getRate(this)
            r = this.rate;
        end
        
        function tput = getTput(this)
            tput = this.tput;
        end
        
        function fer = getFer(this)
            fer = this.numPacketsNOK/(this.numPacketsNOK + this.numPacketsOK);
        end
        
        add(curRate,success)
           
        
        
    end
    
end

