
cwLen = 2690;

s = SimulConfiguration();
s.nIter = 400;
s.snr = logspace(2,3,1);
s.cwLen = cwLen;
s.delay = 10;

pD = ParamDualSat();
pD.addEnvironment('i-tree',1,1,10);
pD.addEnvironment('open',1,200,10);
s.paramDualSat = pD;

s.channel = 'DualSat';

s.linkAdap = 'Dual';

P =  s.createParam()';


simul = SimulMult(P);
simul.simul();
simul.plotTputVsSNR();
simul.plotFerVsSNR();