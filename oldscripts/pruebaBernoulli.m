p = [0.01 0.2 0.5 0.6 0.9];

n = zeros(size(p));
totalN = 5000;
for in=1:length(n)
    ran = rand(1,totalN);
    r = zeros(size(ran));
    r(ran<p(in)) = 1;
    n(in) = sum(r);
end

pEst = StatAckLinkAdap.calculateErrorProb(n,totalN*ones(size(n)));