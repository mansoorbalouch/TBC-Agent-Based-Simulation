import pkg.Agent.*
import pkg.Token.*
import pkg.Platform.*
import pkg.compFundPrice.*

simSteps = 20;

% add/initialize agents
% myAgents = [];
agent1 = Agent( 1, 500, 10, 10, "Noisy");
agent2 = Agent(2, 2000, 2000, 50, "Noisy");
agent3 = Agent(3, 1000, 105, 100, "Noisy");
myAgents = [agent1 agent2 agent3];
% myAgents = createAgent(myAgents, agent1);
% myAgents = createAgent(myAgents, agent2);
% myAgents = createAgent(myAgents, agent3);


buyFunc = @(s) 2*s;
sellFunc = @(s) 1.5*s;
currentSupply = 5;
currentReserve = 70;

% token1 = Token(1, currentPrice, currentSupply, currentReserve);

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

        if actAgents(i).type == "Fundy"
            % deciding to buy/sell token-X and the num of tokens
            fundPrice = compFundPrice(actAgents(i),currentBuyPrice,currentSupply);
            if fundPrice > currentBuyPrice
                action = "mint"
                deltaS = abs(randn(1));
                [currentSupply, currentReserve] = mint(actAgents(i).liquidity, buyFunc, currentSupply,deltaS,currentReserve);
            elseif fundPrice < currentSellPrice
                action = "burn"
                deltaS = abs(randn(1));
                [currentSupply, currentReserve] = burn(actAgents(i).liquidity, sellFunc, currentSupply,deltaS,currentReserve);
            end
        elseif actAgents(i).type =="Charty"
            fundPrice = compFundPrice(actAgents(i),currentBuyPrice,currentSupply)
            if fundPrice > currentBuyPrice
                action = "mint";
                deltaS = abs(randn(1));
                [updatedSupply, updatedReserve] = mint(actAgents(i).liquidity, buyFunc, currentSupply,deltaS,currentReserve);
            elseif fundPrice < currentSellPrice
                action = "burn";
                deltaS = abs(randn(1));
                [currentSupply, currentReserve] = burn(actAgents(i).liquidity, sellFunc, currentSupply,deltaS,currentReserve);
            end
        elseif actAgents(i).type == "Noisy"
            fundPrice = compFundPrice(actAgents(i),currentBuyPrice,currentSupply);
            if fundPrice > currentBuyPrice
                action = "mint";
                deltaS = abs(randn(1));
                [currentSupply, currentReserve] = mint(actAgents(i).liquidity, buyFunc, currentSupply,deltaS,currentReserve);
            elseif fundPrice < currentSellPrice
                action = "burn";
                deltaS = abs(randn(1));
                [currentSupply, currentReserve] = burn(actAgents(i).liquidity, sellFunc, currentSupply,deltaS,currentReserve);
            end
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


           
