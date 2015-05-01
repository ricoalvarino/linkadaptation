%Series simulator
s = SimulConfiguration();
s.nIter = 50000;
s.snr = 10^(30/10);
s.channel = 'ITS';
s.linkAdap = 'LMS2OuterLinkAdap';
s.plotTag = 'LMS2OuterLinkAdap';
P = s.createParam();
%P.channel.rho = 0.1;
P.transmitter.linkAdap.logging = 1;

simul = SimulMult(P);
simul.simul();
