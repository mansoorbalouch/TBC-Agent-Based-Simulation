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
    def __init__(self, numAgents, numSimulationMonths, bondingCurveType, param1, param2, param3=None, save_results_path=None):
        # Initialize properties
        # self.buyFunction = None  # Placeholder for function handle
        # self.sellFunction = None  # Placeholder for function handle
        self.transactionFee = 0.0
        self.discountRate = 0.0
        self.numAgents = numAgents
        self.numTokens = 0  # Initialize as 0, to be updated based on platform logic
        self.myAgents = []  # List to store Agent objects
        self.myTokens = []  # List to store Token objects
        self.numSimulationMonths = numSimulationMonths

        self.bonding_curve_obj = BondingCurve(bondingCurveType, param1_m=param1, param2_c=param2, param3_n=param3)
        self.save_results_path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/Results"
        
        start = timeit.default_timer()
        self.create_agents_and_tokens(self.bonding_curve_obj)
        stop = timeit.default_timer()
        time_new = stop - start
        print("Agent creation time elapsed: ", time_new)

        start = timeit.default_timer()
        self.run_simulation()
        stop = timeit.default_timer()
        time_new = stop - start
        print(f"Simulation time elapsed for {numMonths} months : ", time_new)
 

    def create_agents_and_tokens(self, bonding_curve_obj):
        total_months = 60
        total_years = total_months // 12
        agent_id = 1
        token_id = 1
        j = 0
        self.new_dir = f"{self.bonding_curve_obj.functionType}_TBC_{self.numAgents}Agents_For_{self.numSimulationMonths}Months"
        if not os.path.exists(os.path.join(self.save_results_path, self.new_dir)): # create a new directory for the specific simulation run files
            self.path = os.mkdir(os.path.join(self.save_results_path, self.new_dir)) 
        
        myAgentsfileID = open(f'Results/{self.new_dir}/My_{self.numAgents}Agents_{self.bonding_curve_obj.functionType}_tbc.txt', 'w')
        myAgentsfileID.write('%s %s %s %s %s %s %s %s %s %s\n' % ('AgentID', 'AgentLiquidity', 'AgentPurposeCategory', 'AgentStrategyType', 'RiskAppetite', 'ProActivity', 'IntelligenceGap', 'OwnTokenID', 'DoB', 'DoD'))

        myTokensfileID = open(f'Results/{self.new_dir}/MyTokens_for_{self.numAgents}Agents_{self.bonding_curve_obj.functionType}_tbc.txt', 'w')
        myTokensfileID.write('%s %s %s %s %s\n' % ('TokenID', 'OwnerAgentID', 'LifeCycleCurveShape', 'DoB', 'DoD'))

        agent_purpose_categories = ["Investor", "Creator", "Utilizer", "Speculator"]
        my_agents_purpose_categories = random.choices(agent_purpose_categories, weights=[0.2, 0.1, 0.3, 0.4], k=self.numAgents)

        tbl_token_types_5years_supply_cycles = pd.read_csv("TokenTypes_5Years_SupplyCycles.csv")
        token_types_5years_expected_prices = np.zeros(tbl_token_types_5years_supply_cycles.shape)

        for row in range(tbl_token_types_5years_supply_cycles.shape[0]):
            for column in range(tbl_token_types_5years_supply_cycles.shape[1]):
                token_types_5years_expected_prices[row, column] = bonding_curve_obj.buyFunction(tbl_token_types_5years_supply_cycles.iloc[row, column], bonding_curve_obj.param1, bonding_curve_obj.param2, bonding_curve_obj.param3)

        num_agents_born_per_term = [int(0.03 * self.numAgents), int(0.13 * self.numAgents), int(0.34 * self.numAgents), int(0.34 * self.numAgents), int(0.16 * self.numAgents)] # according to platform adoption life cycle
        dob_ranges_per_term = [range(1,3), range(3,9), range(9,21), range(21,33), range(33,60)] # agents DOB ranges for each term
        
        self.myAgents = [None] * self.numAgents
        for term in range(0, len(num_agents_born_per_term)):
            for i in range(num_agents_born_per_term[term]):
                DOB = random.choices(dob_ranges_per_term[term])[0]
                new_agent = Agent(agent_id, my_agents_purpose_categories[j], DOB, 0 )
                
                if new_agent.purposeCategory == "Creator":
                    life_cycle_curve_shape_id = random.choice(range(1, 29))
                    new_token = Token(token_id, agent_id, token_types_5years_expected_prices, life_cycle_curve_shape_id, new_agent.dayOfBirth, new_agent.dayOfPassing)
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
        numSimulationMinutesPerMonth = 30*24*60
        fileID = open(f'Results/{self.new_dir}/Transactions_log_{self.bonding_curve_obj.functionType}_{self.numAgents}Agents_{self.numSimulationMonths}Months.txt', 'w')
        fileID.write('%s %s %s %s %s %s %s %s %s %s\n' % ('TransactionID', 'AgentID', 'AgentLiquidity', 'TransactionType', 'DeltaSupply', 'TokenID', 'TokenCurrentBuyPrice', 'TokenCurrentSellPrice', 'TokenCurrentSupply', 'SimulationMonth'))

        transactionID = 0
        for simulationMonth in range(1, self.numSimulationMonths + 1):
            
            aliveAgents_dict = dict()
            aliveTokensIDs = [] # [None] * alive_tokens_count
            for i in range(len(self.myAgents)):
                if ((self.myAgents[i].dayOfBirth <= simulationMonth) and (self.myAgents[i].dayOfPassing >= simulationMonth)):
                    if (self.myAgents[i].purposeCategory != "Creator"):
                        aliveAgents_dict[self.myAgents[i].agentID] = self.myAgents[i].proActiveness
                    else:
                        aliveTokensIDs.append(self.myAgents[i].ownTokenId)
            
            if (len(aliveTokensIDs)==0) or (len(aliveAgents_dict)==0): # check if there is no alive token
                print("No alive token or agent, skip this transaction step!!")
                continue 

            # compute the expected prices of all tokens for alive fundy agents
            for i, fundyAgent in enumerate(list(aliveAgents_dict.keys())):
                if self.myAgents[fundyAgent].strategyType == "fundy":
                        self.myAgents[fundyAgent].currentMonthAllTokensExpectedPrices_Fundy = [None]*len(aliveTokensIDs)
                        # Compute the expected prices of all tokens
                        for j, tokenID in enumerate(aliveTokensIDs):
                            # print("AgentID:", self.myAgents[fundyAgent])
                            # print("TokenID", self.myTokens[tokenID])
                            exp_price = sum(w * fp * (1 - self.myAgents[fundyAgent].intelligenceGap) for w, fp in zip(
                                self.myAgents[fundyAgent].monthlyWeights4ExpPrice_Fundy[:self.myAgents[fundyAgent].numTermsForeseen_Fundy],
                                self.myTokens[tokenID].monthlyFairPrices_5years[:self.myAgents[fundyAgent].numTermsForeseen_Fundy]))
                            self.myAgents[fundyAgent].currentMonthAllTokensExpectedPrices_Fundy[j]= round(exp_price, 2)
                        # print("Tokens expected prices (fundy) ", fundyAgent.currentMonthAllTokensExpectedPrices_Fundy)

            for minute in range(numSimulationMinutesPerMonth):
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
                        tokensPriceGaps = [exp_price - self.myTokens[tokenID].currentBuyPrice for exp_price, tokenID in zip(transactingAgent.currentMonthAllTokensExpectedPrices_Fundy, aliveTokensIDs )]
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
                        transactingAgent.currentMonthAllTokensExpectedPrices_Charty = [None]*len(aliveTokensIDs)
                        # Compute the expected prices of all tokens
                        for i, tokenID in enumerate(aliveTokensIDs):
                            hindsightWeights = transactingAgent.monthlyWeights4MvngAvg_Charty
                            averageMonthlyPrices = self.myTokens[tokenID].monthlyPastAveragePrices_5years[:transactingAgent.numHindsightTerms_Charty]
                            weightedMonthlyPrices = sum([w * p for w, p in zip(hindsightWeights, averageMonthlyPrices)])
                            expected_price = (self.myTokens[tokenID].currentBuyPrice + weightedMonthlyPrices) / 2
                            transactingAgent.currentMonthAllTokensExpectedPrices_Charty[i] = expected_price
                        # print("Tokens expected prices (charty) ", allTokensExpectedPrices)

                        # Calculate the price gaps
                        tokensPriceGaps = [exp_price - self.myTokens[tokenID].currentBuyPrice for exp_price, tokenID in zip(transactingAgent.currentMonthAllTokensExpectedPrices_Charty, aliveTokensIDs)]

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

                    # Update the transacting token records
                    token = self.myTokens[transactingTokenID]
                    token.currentSupply += deltaSupply
                    token.currentBuyPrice = self.bonding_curve_obj.buyFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    token.currentSellPrice = self.bonding_curve_obj.sellFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
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
                    fileID.write(f"{transactionID} {transactingAgent.agentID} {transactingAgent.liquidity} buy {deltaSupply} {token.tokenID} "
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
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)

                    # Update the transacting token records
                    token = self.myTokens[transactingTokenID]
                    token.currentSupply -= deltaSupply
                    token.currentBuyPrice = self.bonding_curve_obj.buyFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                    token.currentSellPrice = self.bonding_curve_obj.sellFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
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
                    # if transactingTokenID in transactingAgent.tokenHoldings:
                    transactingAgent.tokenHoldings[transactingTokenID] -= deltaSupply
                    # else:
                        # transactingAgent.tokenHoldings[transactingTokenID] = deltaSupply
                    transactingAgent.liquidity += costDeltaSupply

                    # Log transaction
                    fileID.write(f"{transactionID} {transactingAgent.agentID} {transactingAgent.liquidity} sell {deltaSupply} {token.tokenID} "
                                f"{token.currentBuyPrice} {token.currentSellPrice} {token.currentSupply} {simulationMonth}\n")
                    transactionID +=1

            for i, agent_id in enumerate(aliveAgents_dict.keys()): # token supply clearance of inactive agents
                if (self.myAgents[agent_id].dayOfPassing == simulationMonth):
                    for clearingTokenID in list(self.myAgents[agent_id].tokenHoldings.keys()):
                        deltaSupply = self.myAgents[agent_id].tokenHoldings[clearingTokenID] # return the total holdings of the particular token
                        costDeltaSupply = self.bonding_curve_obj.costDeltaSupply(self.myTokens[clearingTokenID].currentSupply, 
                                                                        self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, deltaSupply, self.bonding_curve_obj.param3)
                        # Update the transacting token records
                        token = self.myTokens[clearingTokenID]
                        token.currentSupply -= deltaSupply
                        token.currentBuyPrice = self.bonding_curve_obj.buyFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                        token.currentSellPrice = self.bonding_curve_obj.sellFunction(token.currentSupply, self.bonding_curve_obj.param1, self.bonding_curve_obj.param2, self.bonding_curve_obj.param3)
                        token.currentMonthPriceRunningSum += token.currentSellPrice
                        token.currentMonthNumTransactionsRunningCount += 1

                        # Update high and low prices for the month
                        if token.currentBuyPrice > token.currentMonthHighestPrice:
                            token.currentMonthHighestPrice = token.currentBuyPrice
                        if token.currentMonthLowestPrice == 0:
                            token.currentMonthLowestPrice = token.currentBuyPrice
                        if token.currentBuyPrice < token.currentMonthLowestPrice:
                            token.currentMonthLowestPrice = token.currentBuyPrice

                        # Update the clearing agent's records
                        self.myAgents[agent_id].tokenHoldings[clearingTokenID] -= deltaSupply
                        self.myAgents[agent_id].liquidity += costDeltaSupply

                        # Log transaction
                        fileID.write(f"{transactionID} {self.myAgents[agent_id].agentID} {self.myAgents[agent_id].liquidity} clearance {deltaSupply} {token.tokenID} "
                                    f"{token.currentBuyPrice} {token.currentSellPrice} {token.currentSupply} {simulationMonth}\n")
                        transactionID +=1


                    

            print(f'Simulation month {simulationMonth} completed...')

        fileID.close()


if __name__ == '__main__':
    param1 = 5
    param2 = 0
    param3 = 2

    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Run simulations for a multi-token economy system..",
                                    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("numAgents", type=int, help="Number of agents", nargs='?', default=500, const=500)
    parser.add_argument("numMonths", type=int, help="Number of months for simulation", nargs='?', default=48, const=48)
    parser.add_argument("bondingCurve", type=str, help="Type of bonding curve")
    # parser.add_argument("batchSize", type=int, help="Batch size")
    

    args = vars(parser.parse_args())
    numAgents = args["numAgents"]
    numMonths = args["numMonths"]
    bondingCurve = args["bondingCurve"]


    platform = Platform(numAgents, numMonths, bondingCurve, param1, param2, param3)
    

# for agent in p.myAgents:
#     # if agent.strategyType == "fundy" and len(agent.currentMonthAllTokensExpectedPrices_Fundy) > 0:
#     if agent.strategyType == "charty" and len(agent.currentMonthAllTokensExpectedPrices_Charty) > 0:
#     # if agent.purposeCategory == "Creator":
#         print(agent)