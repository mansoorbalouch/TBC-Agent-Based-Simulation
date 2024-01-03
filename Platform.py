from Agent import Agent
from Token import Token
from BondingCurve import BondingCurve
import numpy as np
import random
import pandas as pd
import timeit
import argparse
import os

class Platform:
    def __init__(self, numAgents, numSimulationTerms, bondingCurveType, param1, param2, param3=None, save_results_path=None):
        """
        param1: m, param2: c, param3:n
        """
        # Initialize properties
        # self.buyFunction = None  # Placeholder for function handle
        # self.sellFunction = None  # Placeholder for function handle
        self.transactionFee = 0.0
        self.discountRate = 0.0
        self.numAgents = numAgents
        self.numTokens = 0  # Initialize as 0, to be updated based on platform logic
        self.myAgents = []  # List to store Agent objects
        self.myTokens = []  # List to store Token objects
        self.numSimulationTerms = numSimulationTerms

        self.bonding_curve_obj = BondingCurve(bondingCurveType, param1, param2, param3)
        self.save_results_path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/Results"
        
        start = timeit.default_timer()
        self.create_agents_and_tokens(self.bonding_curve_obj)
        # stop = timeit.default_timer()
        # time_new = stop - start
        # print("Agent creation time elapsed: ", time_new)

        # start = timeit.default_timer()
        self.run_simulation()
        stop = timeit.default_timer()
        time_new = stop - start
        print(f"Simulation time elapsed : ", time_new)
        print(f"{self.bonding_curve_obj.functionType} bonding curve simulation completed for {self.numAgents} agents. Parameters: m={self.bonding_curve_obj.param1}, c = {self.bonding_curve_obj.param2}, n={self.bonding_curve_obj.param3}")
 

    def create_agents_and_tokens(self, bonding_curve_obj):
        agent_id = 0
        token_id = 0
        j = 0
        self.new_dir = f"{self.bonding_curve_obj.functionType}_TBC_{self.numAgents}Agents_For_{self.numSimulationTerms}Terms_{self.bonding_curve_obj.param1}m_{self.bonding_curve_obj.param2}c_{self.bonding_curve_obj.param3}n"
        if not os.path.exists(os.path.join(self.save_results_path, self.new_dir)): # create a new directory for the specific simulation run files
            self.path = os.mkdir(os.path.join(self.save_results_path, self.new_dir)) 
        
        myAgentsfileID = open(f'Results/{self.new_dir}/My_{self.numAgents}Agents_{self.bonding_curve_obj.functionType}_tbc.txt', 'w')
        myAgentsfileID.write('%s %s %s %s %s %s %s %s %s %s\n' % ('AgentID', 'AgentLiquidity', 'AgentPurposeCategory', 'AgentStrategyType', 'RiskAppetite', 'ProActivity', 'IntelligenceGap', 'OwnTokenID', 'DoB', 'DoD'))

        myTokensfileID = open(f'Results/{self.new_dir}/MyTokens_for_{self.numAgents}Agents_{self.bonding_curve_obj.functionType}_tbc.txt', 'w')
        myTokensfileID.write('%s %s %s %s %s\n' % ('TokenID', 'OwnerAgentID', 'LifeCycleCurveShape', 'DoB', 'DoD'))

        agent_purpose_categories = ["Investor", "Creator", "Utilizer", "Speculator"]
        my_agents_purpose_categories = random.choices(agent_purpose_categories, weights=[0.2, 0.1, 0.3, 0.4], k=self.numAgents)

        tbl_token_types_3periods_supply_cycles = pd.read_csv("TokenTypes_3Periods_SupplyCycles.csv")
        token_types_3periods_expected_prices = np.zeros(tbl_token_types_3periods_supply_cycles.shape)

        for row in range(tbl_token_types_3periods_supply_cycles.shape[0]):
            for column in range(tbl_token_types_3periods_supply_cycles.shape[1]):
                token_types_3periods_expected_prices[row, column] = bonding_curve_obj.buyFunction(tbl_token_types_3periods_supply_cycles.iloc[row, column], bonding_curve_obj.param1, bonding_curve_obj.param2, bonding_curve_obj.param3)

        num_agents_born_per_term = [int(0.03 * self.numAgents), int(0.13 * self.numAgents), int(0.34 * self.numAgents), int(0.34 * self.numAgents), int(0.16 * self.numAgents)] # according to platform adoption life cycle
        # dob_ranges_per_term = [range(1,3), range(3,9), range(9,21), range(21,33), range(33,60)] # agents DOB ranges for each term --- late adoption ALETHEA
        dob_ranges_per_term = [range(1,5), range(5,13), range(13,21), range(21,29), range(29,33)] # early adoption ALETHEA (agents created in first 8 months = 32 weeks/terms)
        
        self.myAgents = [None] * self.numAgents
        for term in range(0, len(num_agents_born_per_term)):
            for i in range(num_agents_born_per_term[term]):
                DOB = random.choices(dob_ranges_per_term[term])[0]
                new_agent = Agent(agent_id, my_agents_purpose_categories[j], DOB, None )
                
                if new_agent.purposeCategory == "Creator":
                    new_token = Token(token_id, agent_id, token_types_3periods_expected_prices, new_agent.dayOfBirth, new_agent.dayOfPassing)
                    self.myTokens.append(new_token)
                    new_agent.ownTokenId = token_id
                    myTokensfileID.write(f"{new_token.tokenID} {new_token.ownerAgentID} {new_token.lifeCycleCurveShape} {new_agent.dayOfBirth} {new_agent.dayOfPassing}\n")
                
                    token_id += 1

                self.myAgents[j] = new_agent
                myAgentsfileID.write(f"{new_agent.agentID} {new_agent.liquidity} {new_agent.purposeCategory} {new_agent.strategyType} {new_agent.riskAppetite} "
                                f"{new_agent.proActiveness} {new_agent.intelligenceGap} {new_agent.ownTokenId} {new_agent.dayOfBirth} {new_agent.dayOfPassing}\n")
                    
                agent_id += 1
                j += 1
        myAgentsfileID.close()
        myTokensfileID.close()


    def run_simulation(self):
        numSimulationStepsPerTerm = 7*24*60*60 # seconds per week/term
        transactionsLogFileID = open(f'Results/{self.new_dir}/Transactions_log_{self.bonding_curve_obj.functionType}_{self.numAgents}Agents_{self.numSimulationTerms}Terms.txt', 'w')
        transactionsLogFileID.write('%s %s %s %s %s %s %s %s %s %s\n' % ('TransactionID', 'AgentID', 'AgentLiquidity', 'TransactionType', 'DeltaSupply', 'TokenID', 'TokenCurrentBuyPrice', 'TokenCurrentSellPrice', 'TokenCurrentSupply', 'SimulationTerm'))

        agentsWealthDataPerTerm = open(f'Results/{self.new_dir}/Agents_Wealth_Data_{self.bonding_curve_obj.functionType}_{self.numAgents}Agents_{self.numSimulationTerms}Terms.txt', 'w')
        agentIDs = ' '.join(map(str, [int(agentID) for agentID in range(self.numAgents)]))
        agentsWealthDataPerTerm.write(agentIDs + "\n")

        transactionID = 0
        for simulationTerm in range(0, self.numSimulationTerms):
            
            aliveAgents_dict = dict()
            aliveTokensIDs = [] # [None] * alive_tokens_count
            for i in range(len(self.myAgents)):
                if ((self.myAgents[i].dayOfBirth <= simulationTerm) or (self.myAgents[i].dayOfPassing >= simulationTerm)):
                    if (self.myAgents[i].purposeCategory != "Creator"):
                        aliveAgents_dict[self.myAgents[i].agentID] = self.myAgents[i].proActiveness
                    else:
                        aliveTokensIDs.append(self.myAgents[i].ownTokenId)
            
            if (len(aliveTokensIDs)==0) or (len(aliveAgents_dict)==0): # check if there is no alive token
                # print("No alive token or agent, skip this transaction step!!")
                continue 

            # compute the expected prices of all tokens for alive fundy agents
            for fundyAgent in list(aliveAgents_dict.keys()):
                if self.myAgents[fundyAgent].strategyType == "fundy":
                        self.myAgents[fundyAgent].currentTermAllTokensExpectedPrices_Fundy = [0]*len(aliveTokensIDs)
                        # Compute the expected prices of all tokens
                        for j, tokenID in enumerate(aliveTokensIDs):
                            # exp price = w_i * fp_i * (1 +- N(IG, 0.02))
                            exp_price = sum(w * fp * (1 + (random.choices([1,-1])[0] * np.random.normal(self.myAgents[fundyAgent].intelligenceGap, 0.02))) for w, fp in zip(
                                self.myAgents[fundyAgent].weights4ExpPricePerTerm_Fundy[:self.myAgents[fundyAgent].numTermsForeseen_Fundy],
                                self.myTokens[tokenID].fairPricesPerTerm_3periods[simulationTerm-self.myTokens[tokenID].dayOfBirth :self.myAgents[fundyAgent].numTermsForeseen_Fundy]))
                            self.myAgents[fundyAgent].currentTermAllTokensExpectedPrices_Fundy[j]= round(exp_price, 2)
                        # print("Tokens expected prices (fundy) ", fundyAgent.currentTermAllTokensExpectedPrices_Fundy)

            for step in range(numSimulationStepsPerTerm):
                keys = list(aliveAgents_dict.keys())
                weights = [aliveAgents_dict[a] for a in keys]
                transactingAgentID = random.choices(keys, weights=weights)[0]
                transactingAgent = self.myAgents[transactingAgentID]
                # print(transactingAgent)
                action = ""
                transactingTokenID = None
                transactingAgentHoldings = len(transactingAgent.tokenHoldings)

                if (transactingAgentHoldings > 0 or transactingAgent.liquidity > 0):

                    if transactingAgent.strategyType == "noisy":
                        if (transactingAgent.liquidity > 0) and (transactingAgentHoldings > 0):
                            action = random.choice(["buy", "sell"])
                            if action == "buy":
                                transactingTokenID = random.choice([tokenID for tokenID in aliveTokensIDs])
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
                            transactingTokenID = random.choice([tokenID for tokenID in aliveTokensIDs])
                            action = "buy"

                    elif transactingAgent.strategyType == "fundy":

                        # Calculate the price gaps
                        tokensPriceGaps = [exp_price - self.myTokens[tokenID].currentBuyPrice for exp_price, tokenID in zip(transactingAgent.currentTermAllTokensExpectedPrices_Fundy, aliveTokensIDs )]
                        maxPriceGap_AllTokens = max(tokensPriceGaps) if tokensPriceGaps else float('-inf')

                        if transactingAgentHoldings > 0:
                            # Get the price gaps of the already held tokens
                            tokensPriceGaps_HeldTokens = [tokensPriceGaps[tokenID] for tokenID in list(transactingAgent.tokenHoldings.keys())]
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
                        transactingAgent.currentTermAllTokensExpectedPrices_Charty = [None]*len(aliveTokensIDs)
                        # Compute the expected prices of all tokens
                        for i, tokenID in enumerate(aliveTokensIDs):
                            hindsightWeights = transactingAgent.weights4MvngAvgPerTerm_Charty
                            averagePricesPerTerm = self.myTokens[tokenID].pastAveragePricesPerTerm_3periods[simulationTerm-self.myTokens[tokenID].dayOfBirth :transactingAgent.numHindsightTerms_Charty]
                            weightedPricesPerTerm = sum([w * p for w, p in zip(hindsightWeights, averagePricesPerTerm)])
                            expected_price = (self.myTokens[tokenID].currentBuyPrice + weightedPricesPerTerm) / 2
                            transactingAgent.currentTermAllTokensExpectedPrices_Charty[i] = expected_price
                        # print("Tokens expected prices (charty) ", allTokensExpectedPrices)

                        # Calculate the price gaps
                        tokensPriceGaps = [exp_price - self.myTokens[tokenID].currentBuyPrice for exp_price, tokenID in zip(transactingAgent.currentTermAllTokensExpectedPrices_Charty, aliveTokensIDs)]

                        maxPriceGap_AllTokens = max(tokensPriceGaps) if tokensPriceGaps else float('-inf')

                        if transactingAgentHoldings > 0:
                            # Get the price gaps of the already held tokens
                            tokensPriceGaps_HeldTokens = [tokensPriceGaps[tokenID] for tokenID in list(transactingAgent.tokenHoldings.keys())]

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
                   # print(self.myTokens[0])
                                
                if action == "buy":
                    # Choose how much (deltaSupply) to buy based on liquidity or token holdings and risk averseness
                    deltaSupply = random.random()
                    # print("Buying token ID: ", transactingTokenID)
                    costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                    self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)

                    # Check if the cost is within the available liquidity
                    while costDeltaSupply > transactingAgent.liquidity:
                        deltaSupply /= 2
                        costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)
                        # print("cost delta supply computing...")

                    # Update the transacting token records
                    # token = self.myTokens[transactingTokenID]
                    self.myTokens[transactingTokenID].currentSupply += deltaSupply
                    self.myTokens[transactingTokenID].currentBuyPrice = self.bonding_curve_obj.buyFunction(self.myTokens[transactingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    self.myTokens[transactingTokenID].currentSellPrice = self.bonding_curve_obj.sellFunction(self.myTokens[transactingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    self.myTokens[transactingTokenID].currentTermPriceRunningSum += self.myTokens[transactingTokenID].currentSellPrice
                    self.myTokens[transactingTokenID].currentTermNumTransactionsRunningCount += 1

                    # Update high and low prices for the Term
                    if self.myTokens[transactingTokenID].currentBuyPrice > self.myTokens[transactingTokenID].currentTermHighestPrice:
                        self.myTokens[transactingTokenID].currentTermHighestPrice = self.myTokens[transactingTokenID].currentBuyPrice
                    if self.myTokens[transactingTokenID].currentTermLowestPrice == 0 or self.myTokens[transactingTokenID].currentBuyPrice < self.myTokens[transactingTokenID].currentTermLowestPrice:
                        self.myTokens[transactingTokenID].currentTermLowestPrice = self.myTokens[transactingTokenID].currentBuyPrice

                    # Update the transacting agent records
                    if transactingTokenID in self.myAgents[transactingAgentID].tokenHoldings.keys():
                        self.myAgents[transactingAgentID].tokenHoldings[transactingTokenID] += deltaSupply
                    else:
                        self.myAgents[transactingAgentID].tokenHoldings[transactingTokenID] = deltaSupply
        
                    self.myAgents[transactingAgentID].liquidity -= costDeltaSupply

                    # Log transaction
                    transactionsLogFileID.write(f"{transactionID} {self.myAgents[transactingAgentID].agentID} {self.myAgents[transactingAgentID].liquidity} buy {deltaSupply} {self.myTokens[transactingTokenID].tokenID} "
                                f"{self.myTokens[transactingTokenID].currentBuyPrice} {self.myTokens[transactingTokenID].currentSellPrice} {self.myTokens[transactingTokenID].currentSupply} {simulationTerm}\n")
                    transactionID +=1

                elif action == "sell":
                    # print("Selling token ID: ", transactingTokenID)
                    currentHoldingsTransactingToken = self.myAgents[transactingAgentID].tokenHoldings[transactingTokenID] # get the current supply of the held token to be selled
                    deltaSupply = random.random()
                    # print("Token ID: ", transactingTokenID)
                    # print(len(self.myTokens))

                    # Check if the cost is within the available liquidity
                    while deltaSupply > currentHoldingsTransactingToken:
                        deltaSupply /= 2
                        # print("delta supply computing...")
                    
                    costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[transactingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)

                    # Update the transacting token records
                    # token = self.myTokens[transactingTokenID]
                    self.myTokens[transactingTokenID].currentSupply -= deltaSupply
                    self.myTokens[transactingTokenID].currentBuyPrice = self.bonding_curve_obj.buyFunction(self.myTokens[transactingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    self.myTokens[transactingTokenID].currentSellPrice = self.bonding_curve_obj.sellFunction(self.myTokens[transactingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    self.myTokens[transactingTokenID].currentTermPriceRunningSum += self.myTokens[transactingTokenID].currentSellPrice
                    self.myTokens[transactingTokenID].currentTermNumTransactionsRunningCount += 1

                    # Update high and low prices for the Term
                    if self.myTokens[transactingTokenID].currentBuyPrice > self.myTokens[transactingTokenID].currentTermHighestPrice:
                        self.myTokens[transactingTokenID].currentTermHighestPrice = self.myTokens[transactingTokenID].currentBuyPrice
                    if self.myTokens[transactingTokenID].currentTermLowestPrice == 0:
                        self.myTokens[transactingTokenID].currentTermLowestPrice = self.myTokens[transactingTokenID].currentBuyPrice
                    if self.myTokens[transactingTokenID].currentBuyPrice < self.myTokens[transactingTokenID].currentTermLowestPrice:
                        self.myTokens[transactingTokenID].currentTermLowestPrice = self.myTokens[transactingTokenID].currentBuyPrice

                    # Update the transacting agent records
                    self.myAgents[transactingAgentID].tokenHoldings[transactingTokenID] -= deltaSupply
                    self.myAgents[transactingAgentID].liquidity += costDeltaSupply

                    # Log transaction
                    transactionsLogFileID.write(f"{transactionID} {self.myAgents[transactingAgentID].agentID} {self.myAgents[transactingAgentID].liquidity} sell {deltaSupply} {self.myTokens[transactingTokenID].tokenID} "
                                f"{self.myTokens[transactingTokenID].currentBuyPrice} {self.myTokens[transactingTokenID].currentSellPrice} {self.myTokens[transactingTokenID].currentSupply} {simulationTerm}\n")
                    transactionID +=1

            # update the price statistics of tokens to be used by charty agents
            for tokenID in range(len(self.myTokens)):
                if self.myTokens[tokenID].currentTermNumTransactionsRunningCount > 0:
                    self.myTokens[tokenID].pastAveragePricesPerTerm_3periods[simulationTerm] =  self.myTokens[tokenID].currentTermPriceRunningSum/self.myTokens[tokenID].currentTermNumTransactionsRunningCount
                    self.myTokens[tokenID].pastHighPricesPerTerm_3periods[simulationTerm] = self.myTokens[tokenID].currentTermHighestPrice
                    self.myTokens[tokenID].pastLowPricesPerTerm_3periods[simulationTerm] = self.myTokens[tokenID].currentTermLowestPrice
                self.myTokens[tokenID].currentTermPriceRunningSum = 0
                self.myTokens[tokenID].currentTermNumTransactionsRunningCount = 0
                self.myTokens[tokenID].currentTermHighestPrice = 0
                self.myTokens[tokenID].currentTermLowestPrice = 0
                
            # compute the net wealth of alive agents
            netClosingWealthCurrentTermAllTokens = [0]*self.numAgents
            for i, agent_id in enumerate(aliveAgents_dict.keys()): 
                tokensWorth = 0
                if len(self.myAgents[agent_id].tokenHoldings) > 0:
                    for tokenID in list(self.myAgents[agent_id].tokenHoldings.keys()): # loop through the holdings of the current agent
                        tokensWorth += self.myAgents[agent_id].tokenHoldings[tokenID] * self.myTokens[tokenID].currentBuyPrice
                netClosingWealthCurrentTermAllTokens[agent_id] = self.myAgents[agent_id].liquidity + tokensWorth
            netClosingWealthCurrentTermAllTokens = ' '.join(map(str, netClosingWealthCurrentTermAllTokens))
            agentsWealthDataPerTerm.write(netClosingWealthCurrentTermAllTokens + "\n")
                    
            # self.tokenClearanceDyingAgents(aliveAgents_dict, simulationTerm, transactionsLogFileID)
            # transactionID +=1
            # print(f'Simulation Term {simulationTerm} completed...')

        transactionsLogFileID.close()
        agentsWealthDataPerTerm.close()
    
    def tokenClearanceDyingAgents(self, aliveAgents_dict, simulationTerm, transactionID, transactionsLogFileID):
        for i, agent_id in enumerate(aliveAgents_dict.keys()): # token supply clearance of inactive agents
                if (self.myAgents[agent_id].dayOfPassing == simulationTerm) and self.myAgents[agent_id].purposeCategory != "Utilizer":
                    for clearingTokenID in list(self.myAgents[agent_id].tokenHoldings.keys()):
                        deltaSupply = self.myAgents[agent_id].tokenHoldings[clearingTokenID] # return the total holdings of the particular token
                        costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[clearingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)
                        # Update the transacting token records
                        # token = self.myTokens[clearingTokenID]
                        self.myTokens[clearingTokenID].currentSupply -= deltaSupply
                        self.myTokens[clearingTokenID].currentBuyPrice = self.bonding_curve_obj.buyFunction(self.myTokens[clearingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                        self.myTokens[clearingTokenID].currentSellPrice = self.bonding_curve_obj.sellFunction(self.myTokens[clearingTokenID].currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                        self.myTokens[clearingTokenID].currentTermPriceRunningSum += self.myTokens[clearingTokenID].currentSellPrice
                        self.myTokens[clearingTokenID].currentTermNumTransactionsRunningCount += 1

                        # Update high and low prices for the Term
                        if self.myTokens[clearingTokenID].currentBuyPrice > self.myTokens[clearingTokenID].currentTermHighestPrice:
                            self.myTokens[clearingTokenID].currentTermHighestPrice = self.myTokens[clearingTokenID].currentBuyPrice
                        if self.myTokens[clearingTokenID].currentTermLowestPrice == 0:
                            self.myTokens[clearingTokenID].currentTermLowestPrice = self.myTokens[clearingTokenID].currentBuyPrice
                        if self.myTokens[clearingTokenID].currentBuyPrice < self.myTokens[clearingTokenID].currentTermLowestPrice:
                            self.myTokens[clearingTokenID].currentTermLowestPrice = self.myTokens[clearingTokenID].currentBuyPrice

                        # Update the clearing agent's records
                        self.myAgents[agent_id].tokenHoldings[clearingTokenID] -= deltaSupply
                        self.myAgents[agent_id].liquidity += costDeltaSupply

                        # Log transaction
                        transactionsLogFileID.write(f"{transactionID} {self.myAgents[agent_id].agentID} {self.myAgents[agent_id].liquidity} sell {deltaSupply} {self.myTokens[clearingTokenID].tokenID} "
                                    f"{self.myTokens[clearingTokenID].currentBuyPrice} {self.myTokens[clearingTokenID].currentSellPrice} {self.myTokens[clearingTokenID].currentSupply} {simulationTerm}\n")



if __name__ == '__main__':
    # param1 = 50
    # param2 = 30
    # param3 = 60
    # linear & polynomial --- param1: m, param2: c, param3: n
    #     sigmoid --- param1: c, param2: c1, param3: c2 

    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Run simulations for a multi-token economy system..",
                                    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("numAgents", type=int, help="Number of agents", nargs='?', default=500, const=500)
    parser.add_argument("numTerms", type=int, help="Number of terms for simulation", nargs='?', default=48, const=48)
    parser.add_argument("bondingCurve", type=str, help="Type of bonding curve")
    parser.add_argument("param1", type=int, help="param1")
    parser.add_argument("param2", type=int, help="param2")
    parser.add_argument("param3", type=int, help="param3")
    # parser.add_argument("batchSize", type=int, help="Batch size")
    

    args = vars(parser.parse_args())
    numAgents = args["numAgents"]
    numTerms = args["numTerms"]
    bondingCurve = args["bondingCurve"]
    param1 = args["param1"]
    param2 = args["param2"]
    param3 = args["param3"]
    


    platform = Platform(numAgents, numTerms, bondingCurve, param1, param2, param3)
    

# for agent in p.myAgents:
#     # if agent.strategyType == "fundy" and len(agent.currentTermAllTokensExpectedPrices_Fundy) > 0:
#     if agent.strategyType == "charty" and len(agent.currentTermAllTokensExpectedPrices_Charty) > 0:
#     # if agent.purposeCategory == "Creator":
#         print(agent)