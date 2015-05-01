clear all
close all


s = SimulConfiguration();
s.nIter = 100;
s.snr = 10^(15/10)*ones(1,50);
s.channel = 'AR1';
s.rhoAR = 0.9;
s.logSeries = 1;
s.linkAdap = 'LMS2OuterLinkAdap';
s.plotTag = 'LMS 2 Outer - no delay';

P = s.createParam()';

s.plotTag = 'LMS 2 Outer - 5 blocks delay';
s.delay = 5;
P = [P, s.createParam()'];

simul = SimulMult(P);
simul.simul();
simul.plotFerSeries();
simul.plotTputSeries();

