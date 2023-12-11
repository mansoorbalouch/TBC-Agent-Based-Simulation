import pkg.Agent.*
import pkg.Token.*
import pkg.Platform.*
import pkg.mint.*
import pkg.burn.*
import pkg.createAgent.*

Agents = csvread("agents_tbc_simulation.csv");

platform = Platform();
token = Token();

results= table('Size', [0, 4], 'VariableTypes', {'double','double', 'double', 'double'}, ...
    'VariableNames', {'AgentID','CurrentPrice', 'CurrentSupply', 'CurrentReserve'});

numSimulationMonths = 60; % 5 years
numSimulationMinutesPerMonth = 30*24*60;

for month=1:simulationMonths
    %     update the alive agents and their proactiveness lists 
    %     update the monthly record (moving avg, min-max price, DCF, etc.) of all tokens
    %     initialize the buy/sell price of all tokens

    for minute=1:numSimulationMinutesPerMonth
        %    select an alive agent for minute m and perform a transaction
        %    check if the agent has liquidity (>0) and/or tokenholdlings >0

            %   select the tokens that the agent can buy/sell (currentPrice < liquidity and tokenHoldings > 0) 
            %   and store in a list tokensToBeTraded or availableTokens (essentially, the selected agent must perform a transaction)
            
            %    select a token from the list to buy/sell
            %   if "noisy", then select token at random from the list and select buy/sell action

                %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness 
                %   perform transaction and update the token supply and price
                %   [currentSupply, currentReserve] = mint(agent_i.liquidity, buyFunc, currentSupply,deltaS,currentReserve);
                %   [currentSupply, currentReserve] = burn(agent_i.liquidity, sellFunc, currentSupply,deltaS,currentReserve);
                        
            %   if "fundy", compute the fundamental price of all available tokens and the choose
            %   token with highest DCF for buy and lowest fund-price for sell
    
            %   if "charty", estimate the future price of all available
            %   tokens and select the token with highest est-price for buy and lowest est-price for sell
    
    
            %    compute and update the buy and sell price of the traded token
            %   currentBuyPrice = buyFunc(currentSupply);
            %   currentSellPrice = sellFunc(currentSupply);
       
        %    else skip this simulation step --- no transaction


        % append results to the table
        newResults= table(agent_i.agentID, currentBuyPrice, currentSupply, currentReserve, ...
    'VariableNames', {'AgentID','CurrentPrice', 'CurrentSupply', 'CurrentReserve'});

        results = [results; newResults];
        results;
    end
end

% write table data to a CSV file
filename = 'linear_tbc_sim_results.csv'; % File name for the CSV
writetable(results, filename);
disp("Simulation results saved to " + filename);


           
