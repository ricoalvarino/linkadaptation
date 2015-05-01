classdef DualLinkAdap < LinkAdap
    %DualLinkAdap Interface for dual link adaptation: open loop + closed
    %loop
    
    properties
    end
    
    methods
        function o = DualLinkAdap(mcsSet)
           o = o@LinkAdap(mcsSet); 
        end
        observeChannel(this,chan);
    end
    
end

