classdef Feedback
    %FEEDBACK
    
    properties
        param
        CQI
        success
        valid
    end
    
    methods
        function o = Feedback(param,CQI,success)
           if nargin > 0
               o.param = param;
               o.CQI = CQI;
               o.success = success;
               o.valid = 1;
           else
               o.valid = 0;
           end
        end
    end
    
end

