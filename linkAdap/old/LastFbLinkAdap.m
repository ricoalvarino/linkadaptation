classdef LastFbLinkAdap < LinkAdap
    %LastFbLinkAdap Implements link adaptation algorithm that uses last CQI
    %as perfect
    
    properties
    end
    
    methods
        function o = LastFbLinkAdap(mcsSet)
           o = o@LinkAdap(mcsSet);
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);         
        end
        
        function mcs = getMCS(this,param)
            if isempty(this.lastFeedback)
                mcs = 1;
            elseif this.lastFeedback.CQI == 0
                mcs = 1;
            else
                mcs = this.lastFeedback.CQI;
            end
        end
        
        function init(this)
           this.lastFeedback = [];
        end
    end
    
end

