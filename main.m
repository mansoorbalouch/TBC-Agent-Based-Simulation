numAgents = [200, 500, 1000, 2000, 5000];
numSimulationMonths = 2:6;

for simultionRun=1:5
    pobj = Platform(numAgents(simultionRun), numSimulationMonths(simultionRun));
    
end
