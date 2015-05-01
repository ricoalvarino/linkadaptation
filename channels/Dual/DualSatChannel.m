classdef DualSatChannel < DualMIChannel
    %DualSatChannel Implements a dual satellite (RL/FL) channel: same LOS
    %and uncorrelated NLOS
    
    %It should be invoked:
    %   1.- Crosschannel
    %   2.- CrossForwardChannel (2.- will have the same LOS as 1)
    
    properties
        %Regsiter for LOS and NLOS filtering
        regLOS
        regNLOSRL
        regNLOSFL
        
        %Last output of LOS
        lastLOS
        
        %Filters
        aLOS
        aNLOS
        bLOS
        bNLOS
        
        %Parameters:
        rayMP   %Ray mean power
        lnMean  %Mean (in dB) for LOS
        lnVar   %Var (in dB) for LOS
        
        %Object containing the parameters
        param
        
        %Number of channels in a codeword
        cwLen
        
        %CW counter
        cnt
        
        %Index of current channel
        curChan
        
        %Debugging variables
        logLOS
        logNLOSRL
        logNLOSFL
        logRL
        logFL
        logging
    end
    
    methods
        function o = DualSatChannel(snr, paramDualSat,cwLen)
            if nargin > 0
               %Check if we insert channel change
               
               assert(size(paramDualSat.LOS_A,1) == length(paramDualSat.numChan),'filterLOS does not match numChan');
               assert(size(paramDualSat.LOS_B,1) == length(paramDualSat.numChan),'filterNLOS does not match numChan');
               assert(size(paramDualSat.NLOS_A,1) == length(paramDualSat.numChan),'filterLOS does not match numChan');
               assert(size(paramDualSat.NLOS_B,1) == length(paramDualSat.numChan),'filterNLOS does not match numChan');   
               
               assert(mod(cwLen,paramDualSat.decLOS) == 0,'Invalid decimation value (does not divide cwLen)');

               o.param = paramDualSat;
               o.snr = snr;
               o.cwLen = cwLen;
               
               
               o.logging = 0;
               
               o.init();
            end
        end
        
        %Gets one output of the fw channel
        function output = crossForwardChannel(this,input,param)
            %LOS is the same as the RL
            [nlos, this.regNLOSFL] = filter(this.bNLOS,this.aNLOS,1/sqrt(2)*crandn(1,this.cwLen/this.param.decNLOS),this.regNLOSFL);
           
            hlos = 10.^( (this.lastLOS*sqrt(this.lnVar) + this.lnMean) / 20) ;
            hnlos = nlos*10^(this.rayMP/20);
            hnlos = reshape(repmat(hnlos,[this.param.decNLOS,1]),[1, this.param.decNLOS*numel(hnlos)]);
            h = hlos + hnlos;
            
            output = mean(MICalculator.calcMi(abs(h).^2*this.snr,input.modulation));
            
            if this.logging == 1
                this.logNLOSFL = [this.logNLOSFL, hnlos];
                this.logFL = [this.logFL, h];
            end
        end
        
        function output = crossChannel(this,input,param)
            [lastLOSDEC, this.regLOS] = filter(this.bLOS,this.aLOS,randn(1,this.cwLen/this.param.decLOS),this.regLOS);
            [nlos, this.regNLOSRL] = filter(this.bNLOS,this.aNLOS,1/sqrt(2)*crandn(1,this.cwLen/this.param.decNLOS),this.regNLOSRL);
            
            this.lastLOS = reshape(repmat(lastLOSDEC,[this.param.decLOS,1]),[1, this.param.decLOS*numel(lastLOSDEC)]);
            hlos = 10.^( (this.lastLOS*sqrt(this.lnVar) + this.lnMean) / 20);
            hnlos = nlos*10^(this.rayMP/20);
            hnlos = reshape(repmat(hnlos,[this.param.decNLOS,1]),[1, this.param.decNLOS*numel(hnlos)]);            
            h = hlos + hnlos;
            
            output = mean(MICalculator.calcMi(abs(h).^2*this.snr,input.modulation));
            if this.logging == 1
                this.logNLOSRL = [this.logNLOSRL, hnlos];
                this.logLOS = [this.logLOS, hlos];
                this.logRL = [this.logRL, h];
            end
            
            %Decide on channel change
            this.cnt = this.cnt + 1;
            if length(this.param.numChan) > this.curChan
               if this.param.numChan(this.curChan + 1) <= this.cnt
                  this.curChan = this.curChan + 1; 
                  this.aLOS = this.param.LOS_A(this.curChan,:);
                  this.bLOS = this.param.LOS_B(this.curChan,:);
                  this.aNLOS = this.param.NLOS_A(this.curChan,:);
                  this.bNLOS = this.param.NLOS_B(this.curChan,:);
                  this.rayMP = this.param.rayMP(this.curChan);
                  this.lnMean = this.param.lnMean(this.curChan);
                  this.lnVar = this.param.lnVar(this.curChan);                   

               end
            end
        end
        
        function init(o)
           o.aLOS = o.param.LOS_A(1,:);
           o.bLOS = o.param.LOS_B(1,:);
           o.aNLOS = o.param.NLOS_A(1,:);
           o.bNLOS = o.param.NLOS_B(1,:);
           o.rayMP = o.param.rayMP(1);
           o.lnMean = o.param.lnMean(1);
           o.lnVar = o.param.lnVar(1);
           o.cnt = 0;
           o.curChan = 1;
           %Initialize filters: 1000 samples each
           [~, o.regLOS] = filter(o.bLOS,o.aLOS,randn(1,1000));
           [~, o.regNLOSRL] = filter(o.bNLOS,o.aNLOS,1/sqrt(2)*crandn(1,1000));
           [~, o.regNLOSFL] = filter(o.bNLOS,o.aNLOS,1/sqrt(2)*crandn(1,1000));
           o.logLOS = [];
           o.logNLOSRL = [];
           o.logNLOSFL = [];  
           o.logRL = [];
           o.logFL = [];
        end
    end
    
end

