numAgents = 200;
numSimulationMonths = 2;

pobj = Platform(numAgents, numSimulationMonths);

myAgentsPurposeCategory = [pobj.myAgents.purposeCategory];
myAgentsStrategyType = [pobj.myAgents.strategyType];
myAgentsriskAppetite = [pobj.myAgents.riskAppetite];
myAgentsproActiveness = [pobj.myAgents.proActiveness];
myAgentsLiquidity = [pobj.myAgents.liquidity];


f1 = figure();
histogram(categorical(myAgentsPurposeCategory));
title("All Agents by Purpose Category");

f2 = figure();
histogram(categorical(myAgentsStrategyType));
title("All Agents by Strategy Type");

f3 = figure();
plot(myAgentsriskAppetite);
title("All Agents Risk Appetite");

f4 = figure();
plot(myAgentsproActiveness);
title("All Agents Proactiveness");

f5 = figure();
plot(myAgentsLiquidity);
title("All Agents Liquidity");




