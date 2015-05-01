clear all
close all


s = SimulConfiguration();
s.nIter = 100;
s.snr = 10^(15/10)*ones(1,50);
s.channel = 'AR1';
s.rhoAR = 0.1;
s.logSeries = 1;
s.linkAdap = 'SDescent';
s.plotTag = 'SDescent - 15dB';

P = s.createParam()';


simul = SimulMult(P);
simul.simul();
simul.plotFerSeries();
simul.plotTputSeries();

