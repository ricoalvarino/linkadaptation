classdef SeriesAggregator < handle
    %SeriesAggregator Class that aggregates time series of tput and FER
    
    properties
        sTput
        sFer
        numSamples
    end
    
    methods
        function o = SeriesAggregator()
           o.sTput = [];
           o.sFer = [];
           o.numSamples = 0;
        end
        
        function addSeries(this,stat)
           if this.numSamples == 0
              this.sTput = stat.seriesRate.*(stat.seriesOK);
              this.sFer = (1-stat.seriesOK);
              this.numSamples = this.numSamples + 1;
           else
               %We average the previous value with the current one
               this.sTput = this.sTput*this.numSamples/(this.numSamples+1) + stat.seriesRate.*(stat.seriesOK)/(this.numSamples+1);
               this.sFer = this.sFer*this.numSamples/(this.numSamples+1) + (1-stat.seriesOK)/(this.numSamples+1);
               this.numSamples = this.numSamples + 1;
           end
        end
        
        
    end
    
end

