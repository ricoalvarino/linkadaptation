classdef SimulConfiguration
    %SIMULCONFIGURATION Class that contains some default configuration
    %options
       
    properties
       linkAdap
       channel
       nIter
       rateVec
       snr
       targetPer
       plotTag
       probRandomMCS
       logSeries
       %Adaptation step
       muAdap
       %parameters for different channels
       %AR-1
       rhoAR
       
       %Dual Satellite channel
       paramDualSat
       cwLen
       
       %Feedback delay
       delay
    end
    
    methods
        function o = SimulConfiguration()
           o.linkAdap = 'Margin';
           o.channel = 'Gaussian';
           o.nIter = 1000;
           o.rateVec = [0.34 0.39 0.46 0.53 0.61 0.69 0.73 0.77 0.81]*2;
           o.targetPer = 0.1;
           o.probRandomMCS = 0.01;
           o.snr = logspace(-1,3,10);
           o.plotTag = '-----Empty-----';
           o.rhoAR = 0.9;
           o.logSeries = 0;
           o.delay = 0;
           o.cwLen = 128;
           o.muAdap = 0.1;
        end
        
        %Buids MCS object from rateVec
        function m = mcs(this)
           m(length(this.rateVec)) = Mcs(0.1,inf);
           for in=1:length(this.rateVec)
              m(in) = Mcs(this.rateVec(in),4); 
           end
        end
        
        %Creates vector of parameters
        function p = createParam(this)
            p(length(this.snr)) = SimulationParam();
            for in=1:length(this.snr)
                %Boolean that determines if current transmitter has to be
                %dual
                dual = 0;
                m = this.mcs();
                
                %Build channel
                switch this.channel
                    case 'Gaussian'
                        c = GaussianIIDChannel(this.snr(in));
                    case 'GaussianAndLognormal'
                        c = GaussianShadowingIIDChannel(this.snr(in));
                    case 'ITS'
                        c = ITSChannel(this.snr(in));     
                    case 'AR1'
                        c = GaussianAR1(this.snr(in),this.rhoAR);   
                    case 'DualSat'
                        c = DualSatChannel(this.snr(in),this.paramDualSat, this.cwLen);
                        dual = 1;
                    otherwise
                        error('Invalid Channel');
                end
                
                %Build link adaptation object
                switch this.linkAdap
                    case 'Margin'
                        la = MarginLinkAdap(m,this.targetPer,0.1);
                    case 'LMSLinkAdap'
                        la = LMSLinkAdap(m,this.targetPer,this.muAdap);
                    case 'ConstrainedAdap'
                         la = ConstrainedAdap(m,this.targetPer,this.muAdap);
                    case 'PI'
                         la = PI(m,this.targetPer,this.muAdap);                         
                    case 'LMS2OuterLinkAdap'
                        la = LMS2OuterLinkAdap(m,this.targetPer,this.muAdap);                        
                    case 'ARF'
                        la = ARFLinkAdap(m,this.targetPer);                       
                    case 'statACK'
                        la = StatAckLinkAdap(m,this.targetPer,this.probRandomMCS);
                    case 'statCQI'
                        la = StatCQILinkAdap(m,this.targetPer);
                    case 'ARFMod'
                        la = ARF_MLinkAdap(m,this.targetPer,this.muAdap);
                    case 'Dual'
                        la = DualSatAdap(m,this.targetPer);
                    case 'Close'
                        la = CloseSatAdap(m,this.targetPer);                        
                    case 'Open'
                        la = OpenSatAdap(m,this.targetPer);  
                    case 'Convex'
                        la = DualConvexSatAdap(m,this.targetPer);                          
                    otherwise
                        error('Invalid linkAdap option');
                end
                
                %Build transmitter
                txP = TXParam(m,la);
                if (dual == 0)
                    tx = BasicMITransmitter(txP);
                else
                   tx = BasicDualMITransmitter(txP); 
                end
                
                
                %Build receiver
                r = BasicMIReceiver(m);
                r.stats.saveSeries = this.logSeries;
                
                %Put everything into the TxParm object
                p(in).transmitter = tx;
                p(in).channel = c;
                p(in).receiver = r;
                p(in).nIter = this.nIter;
                p(in).plotTag = this.plotTag;
                p(in).feedbackDelay = this.delay;
            end
        end
    end
    
end

