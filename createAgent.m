import pkg.Agent.*
import pkg.Platform.*

% create new agents and add to the agents list
% create n agents with the proportion creators = 10%, investors = 20%, utilizers = 30%, and speculators = 40%
% assign strategies to the agents based on their category
% assign liquidity to each agent agent based on their category

mu_agents_monthly=170; % create 10k agents using the pisson distribution
total_months = 60; 

agentID = 1; % initialize agentID and ownTokenID = 1

agentsBornMonthly = poissrnd(mu_agents_monthly,1,total_months); 

myAgents = table('Size', [0, 13], 'VariableTypes', {'int64','string', 'string', 'double','int64','double','double','double','int64','int64','int64','int64','double'}, ...
    'VariableNames', {'AgentID','PurposeCategory','StrategyType', 'Liquidity', 'Holdings','RiskAppetite', ...
    'ProActiveness','IntelligenceGap','OwnTokenId','DayOfBirth','DayOfPassing','NumTermsForeseen_Fundy','DailyWeights4MvngAvg_Charty'});

platform = Platform();

for month=1:60
    for i = 1:agentsBornMonthly(month)
        DoB = month;

        agent_i = Agent("Investor", month, platform);
        dailyWeights4MvngAvg_Charty = mat2cell([3,6,8],[1],[3]);
        tokenHoldings = mat2cell([0;0],[2],[1]);

        agent = table(agentID, agent_i.purposeCategory, agent_i.strategyType, agent_i.liquidity, tokenHoldings, agent_i.riskAppetite, ...
            agent_i.proActiveness, agent_i.intelligenceGap, agentID, agent_i.dayOfBirth, ...
            agent_i.dayOfPassing, agent_i.numTermsForeseen_Fundy, dailyWeights4MvngAvg_Charty, ...
            'VariableNames', {'AgentID','PurposeCategory','StrategyType', 'Liquidity', 'Holdings','RiskAppetite', ...
    'ProActiveness','IntelligenceGap','OwnTokenId','DayOfBirth','DayOfPassing','NumTermsForeseen_Fundy','DailyWeights4MvngAvg_Charty'});

        myAgents = [myAgents; agent];
        agentID = agentID + 1;

    end

end

% write table data to a CSV file
filename = 'agents_tbc_simulation.csv'; 
writetable(myAgents, filename);
disp("Simulation results saved to " + filename);