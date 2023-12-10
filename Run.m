import pkg.Agent.*
import pkg.Token.*
import pkg.Platform.*
import pkg.compFundPrice.*
import pkg.mint.*
import pkg.burn.*
import pkg.createAgent.*


simSteps = 20;

Agents = csvread("agents_tbc_simulation.csv");

platform = Platform();

results= table('Size', [0, 4], 'VariableTypes', {'double','double', 'double', 'double'}, ...
    'VariableNames', {'AgentID','CurrentPrice', 'CurrentSupply', 'CurrentReserve'});

for t=1:simSteps
    %     select the /alive agents for step t
    actAgents = Agents;
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


           
