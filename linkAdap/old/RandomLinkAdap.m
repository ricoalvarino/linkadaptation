classdef RandomLinkAdap < LinkAdap
    %RandomLinkAdap Implements stupid link adaptation algorithm
    
    properties
    end
    
    methods
        function o = RandomLinkAdap(mcsSet)
           o = o@LinkAdap(mcsSet);
        end
        
        %Updates count of ACK values
        function addFeedback(this,fb)
            %Call the parent method
            addFeedback@LinkAdap(this,fb);         
        end
        
        function mcs = getMCS(this,param)
           mcs = randi([1 length(this.mcsSet)],1,1);
        end
        
        function init(this)
           this.lastFeedback = [];
        end
    end
    
end

