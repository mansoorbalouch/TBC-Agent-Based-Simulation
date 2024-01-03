import random
class Token:
    def __init__(self, tokenID, agentID, tokenTypes_3periods_Expected_Prices, DoB, DoD):
        if tokenID is not None:
            self.tokenID = tokenID
            self.ownerAgentID = agentID
            self.currentBuyPrice = 0
            self.currentSellPrice = 0
            self.currentSupply = 0
            self.dayOfBirth = DoB
            self.dayOfPassing = DoD

            self.currentTermPriceRunningSum = 0
            self.currentTermNumTransactionsRunningCount = 0
            self.currentTermHighestPrice = 0
            self.currentTermLowestPrice = 0

            self.pastAveragePricesPerTerm_3periods = [0] * 144
            self.pastHighPricesPerTerm_3periods = [0] * 144
            self.pastLowPricesPerTerm_3periods = [0] * 144
            self.pastPricesStDevPerTerm_3periods = [0] * 144
            self.pastAvgVolPerTerm_3periods = [0] * 144

            lifeCycleCurveShapes = ["Traditional_1x", "Boom_classic_1x", "Fad_1x", "Revival_1x", "Extended_Fad_1x", "Seasonal_1x", "Bust_1x",
                                    "Traditional_2x", "Boom_classic_2x", "Fad_2x", "Revival_2x", "Extended_Fad_2x", "Seasonal_2x", "Bust_2x",
                                    "Traditional_3x", "Boom_classic_3x", "Fad_3x", "Revival_3x", "Extended_Fad_3x", "Seasonal_3x", "Bust_3x",
                                    "Traditional_4x", "Boom_classic_4x", "Fad_4x", "Revival_4x", "Extended_Fad_4x", "Seasonal_4x", "Bust_4x"]

            self.lifeCycleCurveShape = random.choice(lifeCycleCurveShapes)
            lifeCycleCurveShapeID = lifeCycleCurveShapes.index(self.lifeCycleCurveShape)  # Adjusted for zero-based indexing in Python
            self.fairPricesPerTerm_3periods = tokenTypes_3periods_Expected_Prices[lifeCycleCurveShapeID]  # Adjusted for zero-based indexing
    
    def __str__(self):
        return (f"Token ID: {self.tokenID}, Owner Agent ID: {self.ownerAgentID}\n"
                f"Current Buy Price: {self.currentBuyPrice}, Current Sell Price: {self.currentSellPrice}, Current Supply: {self.currentSupply}\n"
                f"Current Term Price Running Sum: {self.currentTermPriceRunningSum}\n"
                f"Current Term Number of Transactions: {self.currentTermNumTransactionsRunningCount}\n"
                f"Current Term Highest Price: {self.currentTermHighestPrice}, Current Term Lowest Price: {self.currentTermLowestPrice}\n"
                f"Past Average Prices Per Term (3 periods): {self.pastAveragePricesPerTerm_3periods}\n"
                f"Past High Prices Per Term (3 periods): {self.pastHighPricesPerTerm_3periods}\n"
                f"Past Low Prices Per Term (3 periods): {self.pastLowPricesPerTerm_3periods}\n"
                f"Past Prices Standard Deviation Per Term (3 periods): {self.pastPricesStDevPerTerm_3periods}\n"
                f"Past Average Volume Per Term (3 periods): {self.pastAvgVolPerTerm_3periods}\n"
                f"Life Cycle Curve Shape: {self.lifeCycleCurveShape}\n"
                f"Fair Prices Per Term (3 periods): {self.fairPricesPerTerm_3periods}")

# Example usage:
# tokenTypes_3periods_Expected_Prices = [[...], [...], ...]  # List of lists, one for each life cycle curve shape
# token = Token(tokenID=123, agentID=456, tokenTypes_3periods_Expected_Prices=tokenTypes_3periods_Expected_Prices, lifeCycleCurveShapeID=1)
