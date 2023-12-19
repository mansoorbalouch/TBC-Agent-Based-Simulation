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
        function platFormObject = Platform(numAgents,numSimulationMonths)
            if nargin > 0
                platFormObject.buyFunction = @(s) 2* s;
                platFormObject.sellFunction = @(s) 2* s;

                platFormObject.risk_mu_fundy = 0.20;
                platFormObject.risk_sigma_fundy = 0.03;
                platFormObject.risk_mu_charty = 0.40;
                platFormObject.risk_sigma_charty = 0.05;
                platFormObject.risk_mu_noisy = 0.60;
                platFormObject.risk_sigma_noisy = 0.10;

                platFormObject.activity_mu_fundy = 0.15;
                platFormObject.activity_sigma_fundy = 0.04;
                platFormObject.activity_mu_charty = 0.35;
                platFormObject.activity_sigma_charty = 0.09;
                platFormObject.activity_mu_noisy = 0.50;
                platFormObject.activity_sigma_noisy =  0.07;

                platFormObject.midClass_mu_liquidity =  5000;
                platFormObject.midClass_sigma_liquidity =  500;
                platFormObject.rich_mu_liquidity = 10000;
                platFormObject.rich_sigma_liquidity = 1000;
                platFormObject.poor_mu_liquidity = 2000;
                platFormObject.poor_sigma_liquidity = 300;

                platFormObject.intelligencegap_mu_fundy = 20;
                platFormObject.intelligencegap_sigma_fundy = 5;

                platFormObject.numTermsForeseen_mu_fundy = 7;
                platFormObject.numTermsForeseen_sigma_fundy = 1;
                platFormObject.numHindsightTerms_mu_Charty = 7;
                platFormObject.numHindsightTerms_sigma_Charty = 1;


                platFormObject.creator_mu_DayOfPassing =  36;
                platFormObject.creator_sigma_DayOfPassing =  3;
                platFormObject.rich_mu_DayOfPassing = 48;
                platFormObject.rich_sigma_DayOfPassing = 3;
                platFormObject.midClass_mu_DayOfPassing =  24;
                platFormObject.midClass_sigma_DayOfPassing =  3;
                platFormObject.poor_mu_DayOfPassing = 12;
                platFormObject.poor_sigma_DayOfPassing = 2;

                [platFormObject.myAgents,platFormObject.myTokens]  = createAgentsAndTokens(platFormObject,numAgents);
                [platFormObject.myAgents,platFormObject.myTokens] = Run(platFormObject, numSimulationMonths);


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
                    newAgent = Agent(agentID, myAgentsPurposeCategories(j), term, 0, platFormObject);
                    if newAgent.purposeCategory == "Creator"
                        lifeCycleCurveShapeID = randsample([1:28],1);
                        newToken = Token(tokenID, agentID, tokenTypes_5Years_Expected_Prices, lifeCycleCurveShapeID);
                        myTokens = [myTokens, newToken];
                        tokenID = tokenID + 1;
                    end
                    myAgents = [myAgents, newAgent];
                    agentID = agentID + 1;
                    j = j + 1;

                end

            end
        end


        function [myAgents, myTokens] = Run(platFormObject, numSimulationMonths)
            %             numSimulationMinutesPerMonth = 30*24*60;
            numSimulationMinutesPerMonth = 100;

            for simulationMonth=1:numSimulationMonths
                aliveAgents = [];
                for i = 1:numel(platFormObject.myAgents) % get the alive agents
                    if (platFormObject.myAgents(i).dayOfBirth < simulationMonth+1) && (platFormObject.myAgents(i).dayOfPassing > simulationMonth+1) & (platFormObject.myAgents(i).purposeCategory ~= "Creator")
                        aliveAgents = [aliveAgents, platFormObject.myAgents(i)];
                    end
                end

                for minute=1:numSimulationMinutesPerMonth
                    %    select an alive agent for current minute and perform a transaction
                    transactingAgentID = randsample([aliveAgents.agentID], 1, true, double([aliveAgents.proActiveness]));
                    action = "";

                    %    check if the agent has some liquidity or tokenholdlings
                    if (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0)  || (platFormObject.myAgents(transactingAgentID).liquidity > 0)

                        if platFormObject.myAgents(transactingAgentID).strategyType == "noisy"

                            if (platFormObject.myAgents(transactingAgentID).liquidity > 0 ) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0 )    % buy/sell equally likely
                                action = randsample(["buy", "sell"],1);
                                if action == "buy"
                                    transactingTokenID = randsample([platFormObject.myTokens.tokenID], 1);

                                elseif action == "sell" % sell
                                    if width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) == 1 % check if only one token holdings available with the agent
                                        transactingTokenID = platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs;
                                    else
                                        transactingTokenID = randsample([platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs], 1);
                                    end
                                end

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity <= 0 ) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0 ) % can only sell the tokens held
                                if width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) == 1 % check if only one token holdings available with the agent
                                    transactingTokenID = platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs;
                                else
                                    transactingTokenID = randsample([platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs], 1);
                                end
                                action = "sell";

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity > 0 ) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) == 0 ) % can only buy tokens
                                transactingTokenID = randsample([platFormObject.myTokens.tokenID], 1);

                                action = "buy";

                            end

                        elseif platFormObject.myAgents(transactingAgentID).strategyType == "fundy"

                            %   compute the fundamental price of all available tokens and the choose
                            %   token with highest expected price for buy and lowest expected price for sell
                            allTokensExpectedPrices = [];

                            for token=1:numel(platFormObject.myTokens) % compute the expected prices of all tokens
                                syms W(k) FP(k)
                                f = W(k)*FP(k) * (1-platFormObject.myAgents(transactingAgentID).intelligenceGap); % weights * fair prices * (1 - intelligence gap)

                                W = platFormObject.myAgents(transactingAgentID).monthlyWeights4ExpPrice_Fundy(1:platFormObject.myAgents(transactingAgentID).numTermsForeseen_Fundy);
                                FP = platFormObject.myTokens(token).monthlyFairPrices_5years(1:platFormObject.myAgents(transactingAgentID).numTermsForeseen_Fundy);
                                exp_price = symsum(f,k,1,platFormObject.myAgents(transactingAgentID).numTermsForeseen_Fundy);
                                allTokensExpectedPrices(token) = round(sum([subs(exp_price, {'W', 'FP'}, {W, FP})]),2);
                            end

                            tokensPriceGaps = allTokensExpectedPrices - [platFormObject.myTokens.currentBuyPrice]; % price gap = token expected price - token current price (+ve gap represents increasing price and vice versa)
                            tokensPriceGaps_HeldTokens = [];
                            for token=1:numel(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) % get the ids and price gap of the already held tokens
                                tokensPriceGaps_HeldTokens = [tokensPriceGaps_HeldTokens, tokensPriceGaps(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs(token))]; %
                            end
                            minPriceGap_HeldTokens = min(tokensPriceGaps_HeldTokens);
                            maxPriceGap_AllTokens = max(tokensPriceGaps);

                            if (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0)  & (platFormObject.myAgents(transactingAgentID).liquidity > 0)

                                if maxPriceGap_AllTokens > 0 % check if no token is worth buying -- all tokens have -ve price gap
                                    if maxPriceGap_AllTokens > abs(minPriceGap_HeldTokens) % buy the token with max price gap
                                        transactingTokenID = find([tokensPriceGaps] == maxPriceGap_AllTokens);
                                        if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                            transactingTokenID = randsample([transactingTokenID],1);
                                        end
                                        action = "buy";

                                    elseif maxPriceGap_AllTokens < abs(minPriceGap_HeldTokens)  % sell held token with min price gap
                                        transactingTokenID = find([tokensPriceGaps] == minPriceGap_HeldTokens);
                                        if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                            transactingTokenID = randsample([transactingTokenID],1);
                                        end
                                        action = "sell";
                                    end
                                end

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity <= 0) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0) % agent owns tokens only -- sell tokens
                                if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                    transactingTokenID = randsample([transactingTokenID],1);
                                end
                                action = "sell";

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity > 0) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) == 0) % agent has liquidity only --- can only buy tokens
                                maxPriceGap_AllTokens = max(tokensPriceGaps);
                                if maxPriceGap_AllTokens > 0 % check if no token is worth buying
                                    transactingTokenID = find([tokensPriceGaps] == maxPriceGap_AllTokens);
                                    if width(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                        transactingTokenID = randsample([transactingTokenID],1);
                                    end
                                    action = "buy";
                                end
                            end

                        elseif platFormObject.myAgents(transactingAgentID).strategyType == "charty"

                            %   estimate the future price of all available tokens to make buy/sell decisions
                            allTokensExpectedPrices = [];
                            for token=1:numel(platFormObject.myTokens) % compute the expected prices of all tokens

                                weights = platFormObject.myAgents(transactingAgentID).monthlyWeights4MvngAvg_Charty;
                                averageMonthlyPrices = platFormObject.myTokens(token).monthlyPastAveragePrices_5years(1:platFormObject.myAgents(transactingAgentID).numHindsightTerms_Charty);
                                weightedMonthlyPrices = sum(weights.*averageMonthlyPrices);

                                allTokensExpectedPrices(token) = (platFormObject.myTokens(token).currentBuyPrice + weightedMonthlyPrices)/2;
                            end

                            tokensPriceGaps = allTokensExpectedPrices - [platFormObject.myTokens.currentBuyPrice]; % price gap = token expected price - token current price (+ve gap represents increasing price and vice versa)
                            tokensPriceGaps_HeldTokens = [];
                            for token=1:numel(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) % get the ids and price gap of the already held tokens
                                tokensPriceGaps_HeldTokens = [tokensPriceGaps_HeldTokens, tokensPriceGaps(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs(token))]; 
                            end
                            minPriceGap_HeldTokens = min(tokensPriceGaps_HeldTokens);
                            maxPriceGap_AllTokens = max(tokensPriceGaps);

                            if (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0)  & (platFormObject.myAgents(transactingAgentID).liquidity > 0)

                                if maxPriceGap_AllTokens > 0 % check if no token is worth buying -- all tokens have -ve price gap
                                    if maxPriceGap_AllTokens > abs(minPriceGap_HeldTokens) % buy the token with max price gap
                                        transactingTokenID = find([tokensPriceGaps] == maxPriceGap_AllTokens);
                                        if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                            transactingTokenID = randsample([transactingTokenID],1);
                                        end
                                        action = "buy";

                                    elseif maxPriceGap_AllTokens < abs(minPriceGap_HeldTokens)  % sell held token with min price gap
                                        transactingTokenID = find([tokensPriceGaps] == minPriceGap_HeldTokens);
                                        if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                            transactingTokenID = randsample([transactingTokenID],1);
                                        end
                                        action = "sell";
                                    end
                                end

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity <= 0) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) > 0) % agent owns tokens only -- sell tokens
                                if numel(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                    transactingTokenID = randsample([transactingTokenID],1);
                                end
                                action = "sell";

                            elseif (platFormObject.myAgents(transactingAgentID).liquidity > 0) & (width(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) == 0) % agent has liquidity only --- can only buy tokens
                                maxPriceGap_AllTokens = max(tokensPriceGaps);
                                if maxPriceGap_AllTokens > 0 % check if no token is worth buying
                                    transactingTokenID = find([tokensPriceGaps] == maxPriceGap_AllTokens);
                                    if width(transactingTokenID)>1 % if multiple tokens have highest price gaps, then choose one at random
                                        transactingTokenID = randsample([transactingTokenID],1);
                                    end
                                    action = "buy";
                                end
                            end
                        end

                    end

                    if action == "buy"
                        %   choose how much (deltaSupply) to buy/sell based on liquidity or token holdings and risk averseness
                        deltaSupply = rand(1);
                        costDeltaSupply = integral(platFormObject.buyFunction, platFormObject.myTokens(transactingTokenID).currentSupply, platFormObject.myTokens(transactingTokenID).currentSupply + deltaSupply);

                        while costDeltaSupply > platFormObject.myAgents(transactingAgentID).liquidity % check if the cost is within the available liquidity
                            deltaSupply = deltaSupply/2;
                            costDeltaSupply = integral(platFormObject.buyFunction, platFormObject.myTokens(transactingTokenID).currentSupply, platFormObject.myTokens(transactingTokenID).currentSupply + deltaSupply);
                        end

                        % update the transacting token records
                        platFormObject.myTokens(transactingTokenID).currentSupply = platFormObject.myTokens(transactingTokenID).currentSupply + deltaSupply;
                        platFormObject.myTokens(transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
                        platFormObject.myTokens(transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
                        platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum= platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum+ platFormObject.myTokens(transactingTokenID).currentSellPrice;
                        platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount = platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount + 1;

                        if platFormObject.myTokens(transactingTokenID).currentBuyPrice > platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice% check the current price to update the high/low price of the token
                            platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end
                        if platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice == 0
                            platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end
                        if platFormObject.myTokens(transactingTokenID).currentBuyPrice < platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice
                            platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end
%                         platFormObject.myTokens(transactingTokenID)

                        % update the transacting agent records
                        if ismember(transactingTokenID, platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) % if the agent already owns this token -- update the supply
                            tokenHoldingIndex = find(platFormObject.myAgents(transactingAgentID).tokenHoldingsValues == transactingTokenID); % get the index of the owned token and update its supply
                            platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) = platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) + deltaSupply;
                        else % add new token to the agent's token list
                            platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs, transactingTokenID];
                            platFormObject.myAgents(transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents(transactingAgentID).tokenHoldingsValues, deltaSupply];
                        end
                        platFormObject.myAgents(transactingAgentID).liquidity = platFormObject.myAgents(transactingAgentID).liquidity - costDeltaSupply;
%                         platFormObject.myAgents(transactingAgentID)

                    elseif action == "sell"

                        tokenHoldingIndex = find(platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs == transactingTokenID); % get the index of the selected owned token
                        currentHoldingsTransactingToken = platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex); % get the current supply of the held token to be selled
                        deltaSupply = currentHoldingsTransactingToken*rand;
                        if numel(deltaSupply)==0
                            deltaSupply = currentHoldingsTransactingToken * 0.5;
                        end

                        costDeltaSupply = integral(platFormObject.sellFunction, platFormObject.myTokens(transactingTokenID).currentSupply - deltaSupply, platFormObject.myTokens(transactingTokenID).currentSupply);

                        % update the transacting token records
                        platFormObject.myTokens(transactingTokenID).currentSupply = platFormObject.myTokens(transactingTokenID).currentSupply - deltaSupply;
                        platFormObject.myTokens(transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
                        platFormObject.myTokens(transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
                        platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum= platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum+ platFormObject.myTokens(transactingTokenID).currentSellPrice;
                        platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount = platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount + 1;

                        if platFormObject.myTokens(transactingTokenID).currentBuyPrice > platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice% check the current price to update the high/low price of the token
                            platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end
                        if platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice == 0
                            platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end
                        if platFormObject.myTokens(transactingTokenID).currentBuyPrice < platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice
                            platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
                        end

%                         platFormObject.myTokens(transactingTokenID)

                        % update the transacting agent records
                        if ismember(transactingTokenID, platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) % the agent already owns this token -- update the supply
                            tokenHoldingIndex = find(platFormObject.myAgents(transactingAgentID).tokenHoldingsValues == transactingTokenID); % get the index of the owned token and update its supply
                            platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) = platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) - deltaSupply;
                        end
                        platFormObject.myAgents(transactingAgentID).liquidity = platFormObject.myAgents(transactingAgentID).liquidity + costDeltaSupply;
%                         platFormObject.myAgents(transactingAgentID)
                    end
                end

                %     update the monthly record (moving avg, min-max price, etc.) of all tokens
                %     eliminate the liquidity and holdings of the dead agents

                for token=1:numel(platFormObject.myTokens)
                    if platFormObject.myTokens(token).currentMonthNumTransactionsRunningCount > 0
                        platFormObject.myTokens(token).monthlyPastAveragePrices_5years(simulationMonth) =  double(platFormObject.myTokens(token).currentMonthPriceRunningSum)/double(platFormObject.myTokens(token).currentMonthNumTransactionsRunningCount);
                        platFormObject.myTokens(token).monthlyPastHighPrices_5years(simulationMonth) = platFormObject.myTokens(token).currentMonthHighestPrice;
                        platFormObject.myTokens(token).monthlyPastLowPrices_5years(simulationMonth) = platFormObject.myTokens(token).currentMonthLowestPrice;
                    end
                    platFormObject.myTokens(token).currentMonthPriceRunningSum= 0;
                    platFormObject.myTokens(token).currentMonthNumTransactionsRunningCount = 0;
                    platFormObject.myTokens(token).currentMonthHighestPrice= 0;
                    platFormObject.myTokens(token).currentMonthLowestPrice = 0;
                end
                disp(['Simulation month ', num2str(simulationMonth), ' completed...'])

            end
            myAgents = platFormObject.myAgents;
            myTokens = platFormObject.myTokens;

        end

    end
end


%         function [myAgents, myTokens] = buyTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply)
%             % update current token supply, price and token holdings of the transaction agent
%
%             platFormObject.myTokens(transactingTokenID).currentSupply = platFormObject.myTokens(transactingTokenID).currentSupply + deltaSupply;
%             platFormObject.myTokens(transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
%             platFormObject.myTokens(transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
%             platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum= platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum+ platFormObject.myTokens(transactingTokenID).currentSellPrice;
%             platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount = platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount + 1;
%
%             if platFormObject.myTokens(transactingTokenID).currentBuyPrice > platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice% check the current price to update the high/low price of the token
%                 platFormObject.myTokens(transactingTokenID).currentMonthHighestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
%             end
%             if platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice == 0
%                 platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
%             end
%             if platFormObject.myTokens(transactingTokenID).currentBuyPrice < platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice
%                 platFormObject.myTokens(transactingTokenID).currentMonthLowestPrice= platFormObject.myTokens(transactingTokenID).currentBuyPrice;
%             end
%             platFormObject.myTokens(transactingTokenID)
%
%             %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
%             if ismember(transactingTokenID, platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs) % if the agent already owns this token -- update the supply
%                 tokenHoldingIndex = find(platFormObject.myAgents(transactingAgentID).tokenHoldingsValues == transactingTokenID); % get the index of the owned token and update its supply
%                 platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) = platFormObject.myAgents(transactingAgentID).tokenHoldingsValues(tokenHoldingIndex) + deltaSupply;
%             else % add new token to the agent's token list
%                 platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs, transactingTokenID];
%                 platFormObject.myAgents(transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents(transactingAgentID).tokenHoldingsValues, deltaSupply];
%             end
%             platFormObject.myAgents(transactingAgentID).liquidity = platFormObject.myAgents(transactingAgentID).liquidity - costDeltaSupply;
%             platFormObject.myAgents(transactingAgentID)
%
%             myAgents = platFormObject.myAgents;
%             myTokens = platFormObject.myTokens;
%
%         end
%
%         function sellTokens(platFormObject, transactingTokenID, transactingAgentID, deltaSupply, costDeltaSupply)
%             % update current token supply, price and token holdings of the transaction agent
%
%             platFormObject.myTokens(transactingTokenID).currentSupply = platFormObject.myTokens(transactingTokenID).currentSupply - deltaSupply;
%             platFormObject.myTokens(transactingTokenID).currentBuyPrice = platFormObject.buyFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
%             platFormObject.myTokens(transactingTokenID).currentSellPrice = platFormObject.sellFunction(platFormObject.myTokens(transactingTokenID).currentSupply);
%             platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum= platFormObject.myTokens(transactingTokenID).currentMonthPriceRunningSum+ platFormObject.myTokens(transactingTokenID).currentSellPrice;
%             platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount = platFormObject.myTokens(transactingTokenID).currentMonthNumTransactionsRunningCount + 1;
%             platFormObject.myTokens(transactingTokenID)
%
%             %                   transactingToken.currentReserve = transactingToken.currentReserve + costDeltaSupply;
%
%             platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs = [platFormObject.myAgents(transactingAgentID).tokenHoldingsIDs, transactingTokenID];
%             platFormObject.myAgents(transactingAgentID).tokenHoldingsValues = [platFormObject.myAgents(transactingAgentID).tokenHoldingsValues, deltaSupply];
%             platFormObject.myAgents(transactingAgentID).liquidity = platFormObject.myAgents(transactingAgentID).liquidity + costDeltaSupply;
%             platFormObject.myAgents(transactingAgentID)
%
%         end