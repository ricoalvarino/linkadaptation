clear all
close all

%%%%%%%%%%%%% 0.9 %%%%%%%%%%%%%%%%%%%
s = SimulConfiguration();
s.nIter = 1000;
s.snr = logspace(1,3,5);
s.channel = 'AR1';
s.rhoAR = 0;
s.muAdap = 0;
s.linkAdap = 'statCQI';
s.plotTag = 'Statistical CQI';

P = s.createParam()';

s.linkAdap = 'Margin';
s.plotTag = 'Margin';
P = [P s.createParam()'];

s.linkAdap = 'LMSLinkAdap';
s.plotTag = 'LMS';
P = [P s.createParam()'];

s.linkAdap = 'LMS2OuterLinkAdap';
s.plotTag = 'LMS 2 Outer';
P = [P s.createParam()'];

simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();

save experimentRho09