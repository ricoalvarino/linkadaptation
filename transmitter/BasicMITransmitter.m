classdef BasicMITransmitter < MITransmitter
    %BasicMITransmitter Implementation of a basic MI transmitter
    properties
        
    end
    
    methods
        function o = BasicMITransmitter(txParam)
           o = o@MITransmitter(txParam); 
        end
        
        function init(this)
            this.linkAdap.init();
        end
        
        function feedback(this,fObject)
            if (fObject.valid == 1)
                this.linkAdap.addFeedback(fObject);
            end
        end
        
        function [output, param] = newMessage(this)
            param = Param();
            this.msgCounter = this.msgCounter + 1;
            param.idTransmission = this.msgCounter;
            mcsTransmission = this.linkAdap.getMCS(param);
            param.mcs = mcsTransmission;
            param.mcsObj = this.mcsSet(mcsTransmission);
            output = this.mcsSet(mcsTransmission);
        end
    end
    
end

