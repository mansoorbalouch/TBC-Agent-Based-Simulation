% this class defines the system parameters

classdef Platform
    properties
        buyFunction function_handle;
        sellFunction function_handle;
        transactionFee double;
        discountRate double;
        numAgents int16;
        numTokens int16;

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
        numHindsightTerms_mu_Charty int16;
        numHindsightTerms_sigma_Charty int16;

        creator_mu_DayOfPassing int16;
        creator_sigma_DayOfPassing int16;
        rich_mu_DayOfPassing int16;
        rich_sigma_DayOfPassing int16;
        midClass_mu_DayOfPassing int16;
        midClass_sigma_DayOfPassing int16;
        poor_mu_DayOfPassing int16;
        poor_sigma_DayOfPassing int16;

        myAgents(:,:) Agent;
        myTokens(:,:) Token;

%         aliveAgents(:,:) Agent;

    end

    methods
        function platFormObject = Platform(numAgents)
            if nargin > 0
                platFormObject.buyFunction = @(s) 17*s;
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

                platFormObject.numTermsForeseen_mu_fundy = 5;
                platFormObject.numTermsForeseen_sigma_fundy = 2;
                platFormObject.numHindsightTerms_mu_Charty = 5;
                platFormObject.numHindsightTerms_sigma_Charty = 2;


                platFormObject.creator_mu_DayOfPassing =  36;
                platFormObject.creator_sigma_DayOfPassing =  3;
                platFormObject.rich_mu_DayOfPassing = 48;
                platFormObject.rich_sigma_DayOfPassing = 3;
                platFormObject.midClass_mu_DayOfPassing =  24;
                platFormObject.midClass_sigma_DayOfPassing =  3;
                platFormObject.poor_mu_DayOfPassing = 12;
                platFormObject.poor_sigma_DayOfPassing = 2;

                [platFormObject.myAgents,platFormObject.myTokens]  = createAgentsAndTokens(platFormObject,numAgents);



            end

        end


        function [myAgents, myTokens] = createAgentsAndTokens(platFormObject, numAgents)

            % create new agents/tokens and add to the list
            % create n agents with the proportion creators = 10%, investors = 20%, utilizers = 30%, and speculators = 40%
            % assign strategies to the agents based on their category
            % assign liquidity to each agent agent based on their category

            total_months = 60;
            total_years = total_months/12;
            agentID  = 1; % initialize agentID and ownTokenID
            tokenID = 1;
            j=1;

            agentPurposeCategories =[ "Investor", "Creator","Utilizer","Speculator"];
            myAgentsPurposeCategories = randsample(agentPurposeCategories, numAgents,true,[0.2,0.1,0.3,0.4]);
            myAgents = []; 
            myTokens =[]; 

            paramObject = PlformParams(platFormObject.risk_mu_fundy,platFormObject.risk_sigma_fundy,platFormObject.risk_mu_charty,platFormObject.risk_sigma_charty, ...
                platFormObject.risk_mu_noisy,platFormObject.risk_sigma_noisy,platFormObject.activity_mu_fundy,platFormObject.activity_sigma_fundy,platFormObject.activity_mu_charty, ...
                platFormObject.activity_sigma_charty,platFormObject.activity_mu_noisy,platFormObject.activity_sigma_noisy,platFormObject.midClass_mu_liquidity, ...
                platFormObject.midClass_sigma_liquidity ,platFormObject.rich_mu_liquidity ,platFormObject.rich_sigma_liquidity ,platFormObject.poor_mu_liquidity , ...
                platFormObject.poor_sigma_liquidity ,platFormObject.intelligencegap_mu_fundy ,platFormObject.intelligencegap_sigma_fundy ,platFormObject.numTermsForeseen_mu_fundy , platFormObject.numHindsightTerms_mu_Charty, ...
                platFormObject.numHindsightTerms_sigma_Charty, platFormObject.numTermsForeseen_sigma_fundy ,platFormObject.creator_mu_DayOfPassing ,platFormObject.creator_sigma_DayOfPassing ,platFormObject.rich_mu_DayOfPassing , ...
                platFormObject.rich_sigma_DayOfPassing ,platFormObject.midClass_mu_DayOfPassing ,platFormObject.midClass_sigma_DayOfPassing ,platFormObject.poor_mu_DayOfPassing , platFormObject.poor_sigma_DayOfPassing);

%             tblTokenTypes_5Years_SupplyCycles = readtable("TokenTypes_5Years_SupplyCycles.csv");
            tblTokenTypes_5Years_SupplyCycles = csvread("TokenTypes_5Years_SupplyCycles.csv",1,0 );
            tokenTypes_5Years_Expected_Prices = zeros(size(tblTokenTypes_5Years_SupplyCycles));

            for row=1:height(tblTokenTypes_5Years_SupplyCycles)
                for column=1:width(tblTokenTypes_5Years_SupplyCycles)
                    tokenTypes_5Years_Expected_Prices(row,column) = platFormObject.buyFunction(tblTokenTypes_5Years_SupplyCycles(row,column));
%                       platFormObject.buyFunction(tblTokenTypes_5Years_SupplyCycles(row,column)) * 2;
                end
            end


            agentsBornYearly = [0.025*numAgents, 0.135*numAgents, 0.34*numAgents, 0.34*numAgents, 0.16*numAgents];
            for term=1:total_years
                for i = 1:agentsBornYearly(term)
                    newAgent = Agent(agentID, myAgentsPurposeCategories(j), term, 0, paramObject);
                    if newAgent.purposeCategory == "Creator"
                        lifeCycleCurveShapeID = randsample([1:28],1);
                        newToken = Token(tokenID, agentID, 0,0,0, tokenTypes_5Years_Expected_Prices, lifeCycleCurveShapeID);
                        myTokens = [myTokens, newToken];
                        tokenID = tokenID + 1;
                    end
                    myAgents = [myAgents, newAgent];
                    agentID = agentID + 1;
                    j = j + 1;

                end

            end
        end


        function Run(platFormObject, numSimulationMonths)
            numSimulationMinutesPerMonth = 30*24*numSimulationMonths;

            for simulationMonth=1:numSimulationMonths
                aliveAgents = []; 
                for i = 2:numel(platFormObject.myAgents) % get the alive agents
                    if (platFormObject.myAgents(i).dayOfBirth < simulationMonth+1) && (platFormObject.myAgents(i).dayOfPassing > simulationMonth+1)
                        aliveAgents = [aliveAgents, platFormObject.myAgents(i)];
                    end
                end
%                 aliveAgents.proActiveness
                %     initialize the buy/sell price of all tokens

                for minute=1:numSimulationMinutesPerMonth
                    %    select an alive agent for minute m and perform a transaction
                    transactingAgentID = randsample([aliveAgents.agentID], 1, true, double([aliveAgents.proActiveness]));
                    transactingAgent = aliveAgents([aliveAgents.agentID] == transactingAgentID);

                    %    check if the agent has some liquidity or tokenholdlings
                    if ((transactingAgent.liquidity > 0) || (width(transactingAgent.tokenHoldingsIDs) > 0 )) & (transactingAgent.purposeCategory ~= "Creator")

                        if (transactingAgent.strategyType == "noisy")
                            
                            %    choose a buy/sell action
                            if (transactingAgent.liquidity > 0 ) & (width(transactingAgent.tokenHoldingsIDs) > 0 )    % buy/sell equally likely
                                action = randsample(["buy", "sell"],1);
                                if action=="buy"
                                    % compute deltaSupplyMax and decide deltaSupply
                                    transactingTokenID = randsample([platFormObject.myTokens.tokenID], 1);
                                    transactingToken = platFormObject.myTokens(platFormObject.myTokens.tokenID == transactingTokenID);

                                    %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness
                                    deltaSupply = rand(1);

                                    costDeltaSupply = integral(platform.buyFunction, transactingToken.currentSupply, transactingToken.currentSupply + deltaSupply);

%                                     buyTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                                    
                %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
                
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity - costDeltaSupply;
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)

                                    disp("transaction successful!")
                                else % sell
                                    transactingTokenID = randsample([transactingAgent.tokenHoldingsIDs], 1);
                                    transactingToken = platFormObject.myTokens(platFormObject.myTokens.tokenID == transactingTokenID);
                                    deltaSupply = rand(1);

                                    costDeltaSupply = - integral(platFormObject.sellFunction, transactingToken.currentSupply - deltaSupply, transactingToken.currentSupply);

%                                     sellTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply - deltaSupply;
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                                    
                %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
                
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity + costDeltaSupply;
                                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)
                        

                                    disp("transaction successful!")
                                end

                            elseif (transactingAgent.liquidity == 0 ) & (width(transactingAgent.tokenHoldingsIDs) > 0 ) % can only sell the tokens held
                                transactingTokenID = randsample([transactingAgent.tokenHoldingsIDs], 1);
                                transactingToken = platFormObject.myTokens(platFormObject.myTokens.tokenID == transactingTokenID);
                                deltaSupply = rand(1);

                                costDeltaSupply = - integral(platFormObject.sellFunction, transactingToken.currentSupply - deltaSupply, transactingToken.currentSupply);

                                % update current token supply and price

%                                 sellTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply - deltaSupply;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                                
            %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
            
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity + costDeltaSupply;
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)
                    
                                
                                disp("transaction successful!")

                            else % (transactingAgent.liquidity > 0 ) & (size(transactingAgent.tokenHoldingsIDs) == 0 ) % can only buy tokens
%                                 disp("noisy agent transacting...")

                                transactingTokenID = randsample([platFormObject.myTokens.tokenID], 1);
                                transactingToken = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID);

                                %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness
                                deltaSupply = rand(1);

                                costDeltaSupply = integral(platFormObject.buyFunction, transactingToken.currentSupply, transactingToken.currentSupply + deltaSupply);
                                
%                                 buyTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply + deltaSupply;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                                platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                                
            %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
            
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity - costDeltaSupply;
                                platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)
                                
                                disp("transaction successful!")

                            end


                            %   perform transaction and update the token supply and price

                        elseif (transactingAgent.strategyType == "fundy")

                            continue;

                            %   if "fundy", compute the fundamental price of all available tokens and the choose
                            %   token with highest DCF for buy and lowest fund-price for sell

                        elseif (transactingAgent.strategyType == "charty")
                            continue;

                            %   if "charty", estimate the future price of all available
                            %   tokens and select the token with highest est-price for buy and lowest est-price for sell
                        end

                        %    compute and update the buy and sell price of the traded token
                        %   currentBuyPrice = buyFunc(currentSupply);
                        %   currentSellPrice = sellFunc(currentSupply);


                    else
                        %    skip this simulation step --- no transaction
                        disp("Agent has no liquidity or token holdings, skip this simulation step..")

                    end

                end

                
                %     update the monthly record (moving avg, min-max price, etc.) of all tokens
                %     eliminate the liquidity and holdings of the dead agents

                for token=1:numel(platFormObject.myTokens)
                    if platFormObject.myTokens(token).monthlyNumTransactionsRunningSum > 0
                        platFormObject.myTokens(token).monthlyPastAveragePrices_5years(simulationMonth) =  (platFormObject.myTokens(token).monthlyPriceRunningSum)/(platFormObject.myTokens(token).monthlyNumTransactionsRunningSum);
                    end
                    platFormObject.myTokens(token).monthlyPriceRunningSum = 0;
                    platFormObject.myTokens(token).monthlyNumTransactionsRunningSum = 0;                
                end
                disp("Current simulation month completed...")
                              
            end

        end
        
                function buyTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply)
                    % update current token supply, price and token holdings of the transaction agent

                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply + deltaSupply;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                    
%                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;

                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity - costDeltaSupply;
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)
        
                end
        
                function sellTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply)
                    % update current token supply, price and token holdings of the transaction agent

                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply - deltaSupply;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSupply);
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyPriceRunningSum + platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).currentSellPrice;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum = platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID).monthlyNumTransactionsRunningSum + 1;
                    platFormObject.myTokens([platFormObject.myTokens.tokenID] == transactingTokenID)
                    
%                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;

                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).tokenHoldingsValues, deltaSupply];
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity = platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID).liquidity + costDeltaSupply;
                    platFormObject.myAgents([platFormObject.myAgents.agentID] == transactingAgentID)
        
                end


    end
end