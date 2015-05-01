clear all
close all

%%%%%%%%%%%%% 0.9 %%%%%%%%%%%%%%%%%%%
s = SimulConfiguration();
s.nIter = 40000;
s.snr = logspace(2,5,15);
s.channel = 'ITS';
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

save experimentITSCQI