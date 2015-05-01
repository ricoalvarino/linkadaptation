classdef (Abstract) LinkAdap < handle
    %LINKADAP Abstract class for link adaptation algorithms
    
    properties
        lastFeedback
        mcsSet
        %Logging of evolution of internal parameters
        logging
        log
    end
    
    methods
        %Constructor: set MCS set
        function o = LinkAdap(mcs)
            o.mcsSet = mcs;
            o.logging = true;
            o.log = [];
        end
        
        %Simulates the reception of feedback from the receiver. The <fb>
        %parameter must be of Feedback class.
        %This method may be overridden by child classes (and may call this
        %method)
        function addFeedback(this,fb)
            this.lastFeedback = fb;
        end
        
        %Adds new elements to the log
        function addLog(this,val)
           if (this.logging == 1)
            this.log = [this.log, val]; 
           end
        end
        
        %Initializes the link adaptation algorithm
        init(this)
        
        %Returns the MCS to use in the next transmission. This method may
        %use this.lastFeedback to choose the MCS
        mcs = getMCS(this,param)
    end
    
end

