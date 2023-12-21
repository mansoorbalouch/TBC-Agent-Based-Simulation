from Agent import Agent
from Token import Token
from BondingCurve import BondingCurve
import numpy as np
import random
import pandas as pd
import timeit

class Platform:
    def __init__(self, numAgents,bondingCurveType, param1, param2, param3=None):
        # Initialize properties
        self.buyFunction = None  # Placeholder for function handle
        self.sellFunction = None  # Placeholder for function handle
        self.transactionFee = 0.0
        self.discountRate = 0.0
        self.numAgents = numAgents
        self.numTokens = 0  # Initialize as 0, to be updated based on platform logic
        self.myAgents = []  # List to store Agent objects
        self.myTokens = []  # List to store Token objects

        self.bonding_curve_obj = BondingCurve(bondingCurveType, param1=param1, param2=param2, param3=param3)
        
        start = timeit.default_timer()
        self.create_agents_and_tokens(self.bonding_curve_obj)
        stop = timeit.default_timer()
        time_new = stop - start
        print("Agent creation time elapsed: ", time_new)
 

    def create_agents_and_tokens(self, bonding_curve_obj):
        total_months = 60
        total_years = total_months // 12
        agent_id = 0
        token_id = 0
        j = 0

        agent_purpose_categories = ["Investor", "Creator", "Utilizer", "Speculator"]
        my_agents_purpose_categories = random.choices(agent_purpose_categories, weights=[0.2, 0.1, 0.3, 0.4], k=self.numAgents)

        tbl_token_types_5years_supply_cycles = pd.read_csv("TokenTypes_5Years_SupplyCycles.csv")
        token_types_5years_expected_prices = np.zeros(tbl_token_types_5years_supply_cycles.shape)

        for row in range(tbl_token_types_5years_supply_cycles.shape[0]):
            for column in range(tbl_token_types_5years_supply_cycles.shape[1]):
                token_types_5years_expected_prices[row, column] = bonding_curve_obj.buyFunction(tbl_token_types_5years_supply_cycles.iloc[row, column], bonding_curve_obj.param1, bonding_curve_obj.param2)

        agents_born_yearly = [int(0.025 * self.numAgents), int(0.135 * self.numAgents), int(0.34 * self.numAgents), int(0.34 * self.numAgents), int(0.16 * self.numAgents)]
        for term in range(1, total_years + 1):
            for i in range(agents_born_yearly[term - 1]):
                new_agent = Agent(agent_id, my_agents_purpose_categories[j], term, 0 )
                
                if new_agent.purposeCategory == "Creator":
                    life_cycle_curve_shape_id = random.choice(range(1, 29))
                    new_token = Token(token_id, agent_id, token_types_5years_expected_prices, life_cycle_curve_shape_id)
                    self.myTokens.append(new_token)
                    new_agent.ownTokenId = token_id
                    token_id += 1

                self.myAgents.append(new_agent)
                agent_id += 1
                j += 1


    def run_simulation(self, numSimulationMonths):
        numSimulationMinutesPerMonth = 30*24*60
        fileID = open(f'Results/tbc_sim_{self.bonding_curve_obj.functionType}_{self.numAgents}Agents_{numSimulationMonths}Months_transactions_log.txt', 'w')
        fileID.write('%4s %4s %4s %4s %4s %4s %4s %4s %4s %4s \n' % ('TransactionID', 'AgentID', 'AgentLiquidity', 'TransactionType', 'DeltaSupply', 'TokenID', 'TokenCurrentBuyPrice', 'TokenCurrentSellPrice', 'TokenCurrentSupply', 'SimulationMonth'))

        transactionID = 0
        for simulationMonth in range(1, numSimulationMonths + 1):
            aliveAgents = []
            for i, agent in enumerate(self.myAgents):
                if ((agent.dayOfBirth <= simulationMonth) and (agent.dayOfPassing >= simulationMonth) and (agent.purposeCategory != "Creator")):
                    aliveAgents.append(agent)
            
            # compute the expected prices of all tokens for alive fundy agents
            for i, fundyAgent in enumerate(aliveAgents):
                if fundyAgent.strategyType == "fundy":
                        # Compute the expected prices of all tokens
                        for token in self.myTokens:
                            exp_price = sum(w * fp * (1 - fundyAgent.intelligenceGap) for w, fp in zip(
                                fundyAgent.monthlyWeights4ExpPrice_Fundy[:fundyAgent.numTermsForeseen_Fundy],
                                token.monthlyFairPrices_5years[:fundyAgent.numTermsForeseen_Fundy]))
                            fundyAgent.currentMonthAllTokensExpectedPrices_Fundy.append(round(exp_price, 2))
                        # print("Tokens expected prices (fundy) ", fundyAgent.currentMonthAllTokensExpectedPrices_Fundy)

            for minute in range(numSimulationMinutesPerMonth):
                transactingAgent = random.choices(aliveAgents, weights=[a.proActiveness for a in aliveAgents])[0]
                # print(transactingAgent)
                action = ""
                transactingTokenID = None
                transactingAgentHoldings = len(transactingAgent.tokenHoldings)

                if (transactingAgentHoldings > 0 or transactingAgent.liquidity > 0):

                    if transactingAgent.strategyType == "noisy":
                        if (transactingAgent.liquidity > 0) and (transactingAgentHoldings > 0):
                            action = random.choice(["buy", "sell"])
                            if action == "buy":
                                transactingTokenID = random.choice([token.tokenID for token in self.myTokens])
                            elif action == "sell":
                                if transactingAgentHoldings == 1:
                                    transactingTokenID = next(iter(transactingAgent.tokenHoldings))
                                else:
                                    transactingTokenID = random.choice(list(transactingAgent.tokenHoldings.keys()))
                        elif (transactingAgent.liquidity <= 0) and (transactingAgentHoldings > 0):
                            if transactingAgentHoldings == 1:
                                transactingTokenID = next(iter(transactingAgent.tokenHoldings))
                            else:
                                transactingTokenID = random.choice(list(transactingAgent.tokenHoldings.keys()))
                            action = "sell"
                        elif (transactingAgent.liquidity > 0) and (transactingAgentHoldings == 0):
                            transactingTokenID = random.choice([token.tokenID for token in self.myTokens])
                            action = "buy"

                    elif transactingAgent.strategyType == "fundy":

                        # Calculate the price gaps
                        tokensPriceGaps = [exp_price - token.currentBuyPrice for exp_price, token in zip(transactingAgent.currentMonthAllTokensExpectedPrices_Fundy, self.myTokens)]
                        maxPriceGap_AllTokens = max(tokensPriceGaps) if tokensPriceGaps else float('-inf')

                        if transactingAgentHoldings > 0:
                            # Get the price gaps of the already held tokens
                            tokensPriceGaps_HeldTokens = [tokensPriceGaps[token] for token in list(transactingAgent.tokenHoldings.keys())]
                            # Find minimum and maximum price gaps
                            minPriceGap_HeldTokens = min(tokensPriceGaps_HeldTokens) if tokensPriceGaps_HeldTokens else float('inf')

                        # Decide to buy or sell based on the price gaps
                        if transactingAgentHoldings > 0 and transactingAgent.liquidity > 0:
                            if maxPriceGap_AllTokens > 0:
                                if maxPriceGap_AllTokens > abs(minPriceGap_HeldTokens):
                                    transactingTokenID = tokensPriceGaps.index(maxPriceGap_AllTokens)
                                    action = "buy"
                                else:
                                    transactingTokenID = tokensPriceGaps.index(minPriceGap_HeldTokens)
                                    action = "sell"
                        elif transactingAgent.liquidity <= 0 and transactingAgentHoldings > 0:
                            transactingTokenID = tokensPriceGaps.index(minPriceGap_HeldTokens)
                            action = "sell"
                        elif transactingAgent.liquidity > 0 and transactingAgentHoldings == 0:
                            if maxPriceGap_AllTokens > 0:
                                transactingTokenID = tokensPriceGaps.index(maxPriceGap_AllTokens)
                                action = "buy"
                    elif transactingAgent.strategyType == "charty":
                        allTokensExpectedPrices = []

                        # Compute the expected prices of all tokens
                        for token in self.myTokens:
                            hindsightWeights = transactingAgent.monthlyWeights4MvngAvg_Charty
                            averageMonthlyPrices = token.monthlyPastAveragePrices_5years[:transactingAgent.numHindsightTerms_Charty]
                            weightedMonthlyPrices = sum([w * p for w, p in zip(hindsightWeights, averageMonthlyPrices)])
                            expected_price = (token.currentBuyPrice + weightedMonthlyPrices) / 2
                            allTokensExpectedPrices.append(expected_price)
                        # print("Tokens expected prices (charty) ", allTokensExpectedPrices)

                        # Calculate the price gaps
                        tokensPriceGaps = [exp_price - token.currentBuyPrice for exp_price, token in zip(allTokensExpectedPrices, self.myTokens)]

                        # Get the price gaps of the already held tokens
                        tokensPriceGaps_HeldTokens = [tokensPriceGaps[token.tokenID] for token in list(transactingAgent.tokenHoldings.keys())]

                        # Find minimum and maximum price gaps
                        minPriceGap_HeldTokens = min(tokensPriceGaps_HeldTokens) if tokensPriceGaps_HeldTokens else float('inf')
                        maxPriceGap_AllTokens = max(tokensPriceGaps) if tokensPriceGaps else float('-inf')

                        # Decide to buy or sell based on the price gaps
                        if transactingAgentHoldings > 0 and transactingAgent.liquidity > 0:
                            if maxPriceGap_AllTokens > 0:
                                if maxPriceGap_AllTokens > abs(minPriceGap_HeldTokens):
                                    transactingTokenID = tokensPriceGaps.index(maxPriceGap_AllTokens)
                                    action = "buy"
                                else:
                                    transactingTokenID = tokensPriceGaps.index(minPriceGap_HeldTokens)
                                    action = "sell"
                        elif transactingAgent.liquidity <= 0 and transactingAgentHoldings > 0:
                            transactingTokenID = tokensPriceGaps.index(minPriceGap_HeldTokens)
                            action = "sell"
                        elif transactingAgent.liquidity > 0 and transactingAgentHoldings == 0:
                            if maxPriceGap_AllTokens > 0:
                                transactingTokenID = tokensPriceGaps.index(maxPriceGap_AllTokens)
                                action = "buy"
                   # print(self.myTokens[0])
                                
                if action == "buy":
                    # Choose how much (deltaSupply) to buy based on liquidity or token holdings and risk averseness
                    deltaSupply = random.random()
                    # print("Buying token ID: ", transactingTokenID)
                    costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                    self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply)

                    # Check if the cost is within the available liquidity
                    while costDeltaSupply > transactingAgent.liquidity:
                        deltaSupply /= 2
                        costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply)

                    # Update the transacting token records
                    token = self.myTokens[transactingTokenID]
                    token.currentSupply += deltaSupply
                    token.currentBuyPrice = self.bonding_curve_obj.buyFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2)
                    token.currentSellPrice = self.bonding_curve_obj.sellFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2)
                    token.currentMonthPriceRunningSum += token.currentSellPrice
                    token.currentMonthNumTransactionsRunningCount += 1

                    # Update high and low prices for the month
                    if token.currentBuyPrice > token.currentMonthHighestPrice:
                        token.currentMonthHighestPrice = token.currentBuyPrice
                    if token.currentMonthLowestPrice == 0 or token.currentBuyPrice < token.currentMonthLowestPrice:
                        token.currentMonthLowestPrice = token.currentBuyPrice

                    # Update the transacting agent records
                    if transactingTokenID in transactingAgent.tokenHoldings.keys():
                        transactingAgent.tokenHoldings[transactingTokenID] += deltaSupply
                    else:
                        transactingAgent.tokenHoldings[transactingTokenID] = deltaSupply
        
                    transactingAgent.liquidity -= costDeltaSupply

                    # Log transaction
                    fileID.write(f"{transactionID} {transactingAgent.agentID} {transactingAgent.liquidity} buy {deltaSupply} {token.tokenID}  "
                                f"{token.currentBuyPrice} {token.currentSellPrice} {token.currentSupply} {simulationMonth}\n")
                    transactionID +=1

                elif action == "sell":
                    # print("Selling token ID: ", transactingTokenID)
                    currentHoldingsTransactingToken = transactingAgent.tokenHoldings[transactingTokenID] # get the current supply of the held token to be selled
                    deltaSupply = random.random()
                    # print("Token ID: ", transactingTokenID)
                    # print(len(self.myTokens))

                    # Check if the cost is within the available liquidity
                    while deltaSupply > currentHoldingsTransactingToken:
                        deltaSupply /= 2
                    
                    costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply)

                    # Update the transacting token records
                    token = self.myTokens[transactingTokenID]
                    token.currentSupply -= deltaSupply
                    token.currentBuyPrice = self.bonding_curve_obj.buyFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2)
                    token.currentSellPrice = self.bonding_curve_obj.sellFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2)
                    token.currentMonthPriceRunningSum += token.currentSellPrice
                    token.currentMonthNumTransactionsRunningCount += 1

                    # Update high and low prices for the month
                    if token.currentBuyPrice > token.currentMonthHighestPrice:
                        token.currentMonthHighestPrice = token.currentBuyPrice
                    if token.currentMonthLowestPrice == 0:
                        token.currentMonthLowestPrice = token.currentBuyPrice
                    if token.currentBuyPrice < token.currentMonthLowestPrice:
                        token.currentMonthLowestPrice = token.currentBuyPrice

                    # Update the transacting agent records
                    if transactingTokenID in transactingAgent.tokenHoldings:
                        transactingAgent.tokenHoldings[transactingTokenID] -= deltaSupply
                    else:
                        transactingAgent.tokenHoldings[transactingTokenID] = deltaSupply
                    transactingAgent.liquidity += costDeltaSupply

                    # Log transaction
                    fileID.write(f"{transactionID} {transactingAgent.agentID} {transactingAgent.liquidity} sell {deltaSupply} {token.tokenID}  "
                                f"{token.currentBuyPrice} {token.currentSellPrice} {token.currentSupply} {simulationMonth}\n")
                    transactionID +=1

            for i, agent in enumerate(aliveAgents):
                if (agent.dayOfPassing == simulationMonth):
                    agent.tokenHoldings = None
                    

            print(f'Simulation month {simulationMonth} completed...')

        fileID.close()



months = 3
numAgents = 500
bondingCurve = "linear"

p = Platform(numAgents, bondingCurve, 5, 0)
start = timeit.default_timer()
p.run_simulation(months)
stop = timeit.default_timer()
time_new = stop - start
print(f"Simulation time elapsed for {months} months : ", time_new)

# for agent in p.myAgents:
#     if agent.strategyType == "fundy":
#     # if agent.purposeCategory == "Creator":
#         print(agent)