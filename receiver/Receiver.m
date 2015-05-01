classdef (Abstract) Receiver < handle
    %RECEIVER Abstract class for receivers (really??)
    
    properties
        stats
    end
    
    methods
        function o = Receiver()
           o.stats = StatsAvgTput(); 
        end
        
        function s = getStats(this)
           s = this.stats; 
        end
        
        init(this)
        
        decode(outChannel,param)
        
        fb = getFeedback(this)
        
    end
    
end

