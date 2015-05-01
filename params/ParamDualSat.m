classdef ParamDualSat < handle
    %PARAMDUALSAT Contains config parameters for dual satellite channel
    
    properties
        %Filters for LOS and NLOS
        LOS_A
        LOS_B
        NLOS_A
        NLOS_B
        
        %Power values
        rayMP               %Rayleigh mean power
        lnMean              %Mean (in dB) of lognormal shadowing
        lnVar               %Variance (in dB) of " "     "  "
        
        %Switch after x channels
        %The first value can be anything, the system will switch to the
        %second filter/parameters when numChan(2) codewords are generated
        numChan
        
        %Decimation of LOS: hack to skip problems with filters with very
        %small bandpass
        decLOS
        decNLOS
        %Operating parameters
        fc
        Tsymb
    end
    
    methods
        function o = ParamDualSat()
           o.fc =  1550e6;
           o.Tsymb = 1/(33.6e3);
           o.decLOS = 300;
           o.decNLOS = 30;
        end
        function mFilter(this,n)
            this.LOS_A = repmat(this.LOS_A,[n,1]);
            this.LOS_B = repmat(this.LOS_B,[n,1]);
            this.NLOS_A = repmat(this.NLOS_A,[n,1]);
            this.NLOS_B = repmat(this.NLOS_B,[n,1]);            
        end
        
        function [dcorr,alpha,Psi,MP] = obtain_fontan_params(this,environment,state,elevation)
            if (elevation==40), % Tables for the different scenarios:
                switch environment
                    case 'test'
                        %             P = [1/3 1/3 1/3; 1/3 1/3 1/3; 1/3 1/3 1/3]; % Transition matrix
                        %             W = [1/3; 1/3; 1/3]; % State probability
                        dcorr  = 2.81;          % m
                        %             Lframe = [20;10;5];     % m
                        %             Ltrans = 5;             % m
                        alpha  = [  5; 0; -5];  % dB
                        Psi    = [  3; 1; 2];   % dB
                        MP     = [-25.0; -10.0; -5.0];  % dB
                    case 'open'
                        %             P = [0.9530 0.0431 0.0039; 0.0515 0.9347 0.0138; 0.0334 0.0238 0.9428]; % Transition matrix
                        %             W = [0.500; 0.375; 0.0125]; % State probability
                        dcorr  = 2.5;           % m
                        %             Lframe = [8.9;7.5;4.0]; % m
                        %             Ltrans = 12.4;          % m
                        alpha  = [  0.10; -1.0;  -2.25]; % dB
                        Psi    = [  0.37;  0.5;   0.13]; % dB
                        MP     = [-22.0; -22.0; -21.2];  % dB
                    case 'suburban'
                        %             P = [0.8177 0.1715 0.0108; 0.1544 0.7997 0.0459; 0.1400 0.1433 0.7167]; % Transition matrix
                        %             W = [0.4545; 0.4545; 0.091]; % State probability
                        dcorr  = 1.7;           % m
                        %             Lframe = [5.2;3.7;3.0]; % m
                        %             Ltrans = 2.2;           % m
                        alpha  = [ -1.0;  -3.7; -15.0]; % dB
                        Psi    = [  0.5;   .98;   5.9]; % dB
                        MP     = [-13.0; -12.2; -13.0]; % dB
                    case 'i-tree'
                        %             P = [0.7193 0.1865 0.0942; 0.1848 0.7269 0.0883; 0.1771 0.0971 0.7258]; % Transition matrix
                        %             W = [0.3929; 0.3571; 0.25]; % State probability
                        dcorr  = 1.5;           % m
                        %             Lframe = [6.3;6.3;4.5]; % m
                        %             Ltrans = 2.6;           % m
                        alpha  = [ -0.4;  -8.2; -17.0]; % dB
                        Psi    = [  1.5;   3.9;  3.14]; % dB
                                    MP     = [-13.2; -12.7; -10.0]; % dB
            %             MP     = [-22 -30 -48]; % dB
                    case 'h-tree'
                        %             P = [1/3 1/3 1/3; 0 0.9259 0.0741; 0 0.0741 0.9259]; % Transition matrix
                        %             W = [0; 0.5; 0.5]; % State probability
                        dcorr  = 1.7;         % m
                        %             Lframe = [0;4.8;4.5]; % m
                        %             Ltrans = 3.5;         % m
                        alpha  = [     -10.1; -19.0]; % dB
                        Psi    = [      2.25;   4.0]; % dB
                        MP     = [     -10.0; -10.0]; % dB
                        %        MP     = [    -100; -100; -100]; % dB
                    otherwise
                        fprintf('Error: Elevation ok. Environment not supported.\n');
                        dcorr =0; alpha=0; Psi=0; MP =0;
                end
            else
                fprintf('Error: Elevation not supported.\n');
                dcorr =0; alpha=0; Psi=0; MP =0;
            end

            alpha = alpha(state);
            Psi = Psi(state);
            MP = MP(state);
        end
        
        %Adds environment to the simulation
        %env: environment: ITS, open, etc
        %State: Fontan state (integer)
        %NumCW: number of cw to simulate in this state
        %Speed: Speed (in m/s) to determine the filter size
        function addEnvironment(this,env,state,numCW,speed)
            %Obtain parameters of fontan state
            [dcorr,alpha,Psi,MP] = this.obtain_fontan_params(env,state,40);
            this.rayMP = [this.rayMP, MP];
            this.lnMean = [this.lnMean, alpha];
            this.lnVar = [this.lnVar, Psi];
            
            %Add numbr of codewords
            this.numChan = [this.numChan, numCW];
            
            %Generate filters: calculate fd and fdLOS.
            fd = this.fc*speed*this.Tsymb/3e8*this.decNLOS;
            fdLOS = speed*this.Tsymb*this.decLOS/dcorr;
            
            [bLOS,aLOS] = design_filter(fdLOS);
            this.LOS_A = [this.LOS_A; aLOS];
            this.LOS_B = [this.LOS_B; bLOS];
            
            [bNLOS,aNLOS] = design_filter(fd);
            this.NLOS_A = [this.NLOS_A; aNLOS];
            this.NLOS_B = [this.NLOS_B; bNLOS];
            
            
        end
            
        
    end
    
end

