clear all
close all

%%%%%%%%%%%%% 0.9 %%%%%%%%%%%%%%%%%%%
s = SimulConfiguration();
s.nIter = 8000;
s.snr = logspace(2,5,10);
s.channel = 'ITS';
s.linkAdap = 'SDescent';
s.plotTag = 'SDescent';

P = s.createParam()';


simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

%save experimentITS