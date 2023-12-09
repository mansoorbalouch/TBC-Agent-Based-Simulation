import pkg.Agent.*
import pkg.Token.*
import pkg.Platform.*
import pkg.compFundPrice.*
import pkg.mint.*
import pkg.burn.*
import pkg.createAgent.*


simSteps = 20;

% add/initialize agents
% myAgents = [];
agent1 = Agent( 1, 500, [2,4,6;7,5,8], 10, "Noisy",2);
agent2 = Agent(2, 2000, [3,5,7;6,8,10], 50, "Noisy",6);
agent3 = Agent(3, 1000, [1,6,9;12,26,11], 100, "Noisy",4);
myAgents = [agent1 agent2 agent3];
% myAgents = createAgent(myAgents, agent1);
% myAgents = createAgent(myAgents, agent2);
% myAgents = createAgent(myAgents, agent3);


buyFunc = @(s) 2*s;
sellFunc = @(s) 1.5*s;
currentSupply = 5;
currentReserve = 70;

token1 = Token(1, currentPrice, currentSupply, currentReserve);
token2 = Token(2, currentPrice, currentSupply, currentReserve);
token3 = Token(3, currentPrice, currentSupply, currentReserve);


paltform = Platform(buyFunc, sellFunc);

results= table('Size', [0, 4], 'VariableTypes', {'double','double', 'double', 'double'}, ...
    'VariableNames', {'AgentID','CurrentPrice', 'CurrentSupply', 'CurrentReserve'});

for t=1:simSteps
    %     select the active agents for step t
    actAgents = myAgents;
    numActAgents = length(myAgents);

    %    loop through the active agents and perform transactions
    for i=1:numActAgents

        %    compute/update the buy and sell price
        currentBuyPrice = buyFunc(currentSupply);
        currentSellPrice = sellFunc(currentSupply);

        % deciding to buy/sell token-X and the num of tokens
        estPrice = estPrice(actAgents(i),currentBuyPrice,currentSupply);

        if estPrice > currentBuyPrice
            deltaS = abs(randn(1));
            [currentSupply, currentReserve] = mint(actAgents(i).liquidity, buyFunc, currentSupply,deltaS,currentReserve);
        elseif estPrice < currentSellPrice
            deltaS = abs(randn(1));
            [currentSupply, currentReserve] = burn(actAgents(i).liquidity, sellFunc, currentSupply,deltaS,currentReserve);
        end

        % append results to the table
        newResults= table(actAgents(i).agentID, currentBuyPrice, currentSupply, currentReserve, ...
    'VariableNames', {'AgentID','CurrentPrice', 'CurrentSupply', 'CurrentReserve'});

        results = [results; newResults];
        results;
    end
end

% write table data to a CSV file
filename = 'linear_tbc_sim_results.csv'; % File name for the CSV
writetable(results, filename);
disp("Simulation results saved to " + filename);


           