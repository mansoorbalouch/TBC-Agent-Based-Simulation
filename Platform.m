% this class defines the system parameters

classdef Platform
    properties
        buyFunction function_handle;
        sellFunction function_handle;
        transactionFee double;
        discountRate double;
        numAgents int16;
        numTokens int16;

        myAgents(:,1) Agent;
        myToken(:,1) Token;


        % The following assume that we have different normal
        % distributions to draw the risk appetite and proActiveness
        % for each type of agents by strategy
        % type agent. The parameters of these normal distributions,
        % risk_mu_charty, risk_mu_charty, etc. are Platform variables

        risk_mu_fundy double;
        risk_sigma_fundy double;
        risk_mu_charty double;
        risk_sigma_charty double;
        risk_mu_noisy double;
        risk_sigma_noisy double;

        activity_mu_fundy double;
        activity_sigma_fundy double;
        activity_mu_charty double;
        activity_sigma_charty double;
        activity_mu_noisy double;
        activity_sigma_noisy double;

        midClass_mu_liquidity double;
        midClass_sigma_liquidity double;
        rich_mu_liquidity double;
        rich_sigma_liquidity double;
        poor_mu_liquidity double;
        poor_sigma_liquidity double;

        intelligencegap_mu_fundy double;
        intelligencegap_sigma_fundy double;

        numTermsForeseen_mu_fundy int16;
        numTermsForeseen_sigma_fundy int16;

        creator_mu_DayOfPassing int16;
        creator_sigma_DayOfPassing int16;
        rich_mu_DayOfPassing int16;
        rich_sigma_DayOfPassing int16;
        midClass_mu_DayOfPassing int16;
        midClass_sigma_DayOfPassing int16;
        poor_mu_DayOfPassing int16;
        poor_sigma_DayOfPassing int16; 

    end

    methods
        function platFormObject = Platform()
%             if nargin > 0
                platFormObject.buyFunction = @(s) 2*s;
                platFormObject.sellFunction = @(s) 1.5*s;

                platFormObject.risk_mu_fundy = 20;
                platFormObject.risk_sigma_fundy = 3;
                platFormObject.risk_mu_charty = 40;
                platFormObject.risk_sigma_charty = 5;
                platFormObject.risk_mu_noisy = 60;
                platFormObject.risk_sigma_noisy = 10;

                platFormObject.activity_mu_fundy = 15;
                platFormObject.activity_sigma_fundy = 4;
                platFormObject.activity_mu_charty = 35;
                platFormObject.activity_sigma_charty = 9;
                platFormObject.activity_mu_noisy = 50;
                platFormObject.activity_sigma_noisy =  7;

                platFormObject.midClass_mu_liquidity =  5000;
                platFormObject.midClass_sigma_liquidity =  500;
                platFormObject.rich_mu_liquidity = 10000;
                platFormObject.rich_sigma_liquidity = 1000;
                platFormObject.poor_mu_liquidity = 2000;
                platFormObject.poor_sigma_liquidity = 300;

                platFormObject.intelligencegap_mu_fundy = 20;
                platFormObject.intelligencegap_sigma_fundy = 5;
                
                platFormObject.numTermsForeseen_mu_fundy = 18;
                platFormObject.numTermsForeseen_sigma_fundy = 3;


                platFormObject.creator_mu_DayOfPassing =  36;
                platFormObject.creator_sigma_DayOfPassing =  3;
                platFormObject.rich_mu_DayOfPassing = 48;
                platFormObject.rich_sigma_DayOfPassing = 3;
                platFormObject.midClass_mu_DayOfPassing =  24;
                platFormObject.midClass_sigma_DayOfPassing =  3;
                platFormObject.poor_mu_DayOfPassing = 12;
                platFormObject.poor_sigma_DayOfPassing = 2;      

%                  [myAgents, myTokens] = createAgentsAndTokens(500);
%             end

        end

        function [myAgents, myTokens] = createAgentsAndTokens(numAgents)

            % create new agents/tokens and add to the list
            % create n agents with the proportion creators = 10%, investors = 20%, utilizers = 30%, and speculators = 40%
            % assign strategies to the agents based on their category
            % assign liquidity to each agent agent based on their category
            
%             myAgents = [];
%             myTokens = [];
            total_months = 60; 
            total_years = total_months/12;
            
            agentID  = 1; % initialize agentID and ownTokenID 
            tokenID = 1;
            j=1;
            
            agentPurposeCategories =[ "Investor", "Creator","Utilizer","Speculator"];
            myAgentsPurposeCategories = randsample(agentPurposeCategories, numAgents,true,[0.2,0.1,0.3,0.4]);
            
            % agentsBornMonthly = poissrnd(mu_agents_monthly,1,total_months); 
            agentsBornYearly = [0.025*numAgents, 0.0135*numAgents, 0.34*numAgents, 0.34*numAgents, 0.16*numAgents];
            
            
            for term=1:total_years
                for i = 1:agentsBornYearly(term)
                    agent_i = Agent(myAgentsPurposeCategories(j), term, Platform);
                               
                    newAgent = [agentID, agent_i.purposeCategory, agent_i.strategyType, agent_i.liquidity, tokenHoldingsIDs, tokenHoldingsValues, ...
                        agent_i.riskAppetite, agent_i.proActiveness, agent_i.intelligenceGap, agentID, agent_i.dayOfBirth, ...
                        agent_i.dayOfPassing, agent_i.numTermsForeseen_Fundy, dailyWeights4MvngAvg_Charty];
                
                    if agent_i.purposeCategory == "Creator"
                    
                        token_i = Token(tokenID, agentID, 0,0,0); 
                        newToken = [tokenID, agentID, token_i.currentBuyPrice, token_i.currentSellPrice, token_i.currentSupply, token_i.lifeCycleCurveShape, ...
                            token_i.monthlyExpectedDiscountedPrices_5years, token_i.monthlyPastAveragePrices_5years, token_i.monthlyPastHighPrices_5years, ...
                            token_i.monthlyPastLowPrices_5years, token_i.monthlyPastPricesStDev_5years, token_i.monthlyPastAvgVol_5years];
                        myTokens = [myTokens; newToken];
                        tokenID = tokenID + 1;
                    end
                
                    myAgents = [myAgents; newAgent];
                    
                    
                    agentID = agentID + 1;
                    j = j + 1;
                
                end
            
            end
        end


        function Run(myAgents, myTokens, numSimulationMonths, platform)
            numSimulationMinutesPerMonth = 30*24*numSimulationMonths;
%             myAgents = readtable("agents_tbc_simulation.csv");
            
            for simulationMonth=1:numSimulationMonths
                aliveAgents = myAgents(myAgents.DayOfBirth < simulationMonth+1 & myAgents.DayOfPassing > simulationMonth+1 ,:) ;

                %     update the monthly record (moving avg, min-max price, DCF, etc.) of all tokens
                %     initialize the buy/sell price of all tokens
            
                for minute=1:numSimulationMinutesPerMonth
                   %    select an alive agent for minute m and perform a transaction
                    transactingAgentID = randsample(aliveAgents.AgentID, 1, true, aliveAgents.ProActiveness);
                    transactingAgent = aliveAgents(aliveAgents.AgentID == transactingAgentID,:);

                 %    check if the agent has some liquidity or tokenholdlings
                   if (transactingAgent.Liquidity > 0) || (transactingAgent.Holdings > 0 )  
                    
                        if (transactingAgent.StrategyType == "noisy")
                        %    choose a buy/sell action
                            if (transactingAgent.Liquidity > 0 ) && (transactingAgent.Holdings > 0 ) % buy/sell equally likely
                                action = randsample(["buy", "sell"],1);
                                if action=="buy"
                                    % compute deltaSupplyMax and decide deltaSupply
                                    transactingTokenID = randsample(myTokens.TokenID, 1);
                                    transactingToken = myTokens(myTokens.TokenID == transactingTokenID,:);

                                    %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness 
                                    
                                    costDeltaSupply = integral(platform.buyFunction, currentSupply, currentSupply + deltaSupply);

                                    % update current token supply and price

                                    transactingToken.currentSupply = transactingToken.currentSupply + deltaSupply;
                                    transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
                                else % sell
                                    transactingTokenID = randsample(transactingAgent.Holdings, 1);
                                    transactingToken = myTokens(myTokens.TokenID == transactingTokenID,:);
                                    
                                    costDeltaSupply = - integral(platform.sellFunction, currentSupply - deltaSupply, currentSupply);

                                    % update current token supply and price

                                    transactingToken.currentSupply = transactingToken.currentSupply - deltaSupply;
                                    transactingToken.currentReserve = transactingToken.currentReserve - costDeltaSupply;
                                end

                            elseif (transactingAgent.Liquidity == 0 ) && (transactingAgent.Holdings > 0 ) % can only sell the tokens held
                                transactingTokenID = randsample(transactingAgent.Holdings, 1);
                                transactingToken = myTokens(myTokens.TokenID == transactingTokenID,:);
                                
                                costDeltaSupply = - integral(platform.sellFunction, currentSupply - deltaSupply, currentSupply);

                                % update current token supply and price

                                transactingToken.currentSupply = transactingToken.currentSupply - deltaSupply;
                                transactingToken.currentReserve = transactingToken.currentReserve - costDeltaSupply;

                            elseif (transactingAgent.Liquidity > 0 ) && (transactingAgent.Holdings == 0 ) % can only buy tokens

                                transactingTokenID = randsample(myTokens.TokenID, 1);
                                transactingToken = myTokens(myTokens.TokenID == transactingTokenID,:);

                                %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness 
                                
                                costDeltaSupply = integral(platform.buyFunction, currentSupply, currentSupply + deltaSupply);

                                % update current token supply and price

                                transactingToken.currentSupply = transactingToken.currentSupply + deltaSupply;
                                transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
                                
                            end
            
                            
                            %   perform transaction and update the token supply and price
                        
                        elseif (transactingAgent.StrategyType == "fundy")

                        %   if "fundy", compute the fundamental price of all available tokens and the choose
                        %   token with highest DCF for buy and lowest fund-price for sell

                        elseif (transactingAgent.StrategyType == "charty")
                
                        %   if "charty", estimate the future price of all available
                        %   tokens and select the token with highest est-price for buy and lowest est-price for sell
                        end
                
                        %    compute and update the buy and sell price of the traded token
                        %   currentBuyPrice = buyFunc(currentSupply);
                        %   currentSellPrice = sellFunc(currentSupply);
                   
                    
                   else
                       %    skip this simulation step --- no transaction

                    end
            
                end
            end

        end



    end
end