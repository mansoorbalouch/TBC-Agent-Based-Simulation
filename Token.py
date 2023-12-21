class Token:
    def __init__(self, tokenID=None, agentID=None, tokenTypes_5Years_Expected_Prices=None, lifeCycleCurveShapeID=None):
        if tokenID is not None:
            self.tokenID = tokenID
            self.ownerAgentID = agentID
            self.currentBuyPrice = 0
            self.currentSellPrice = 0
            self.currentSupply = 0

            self.currentMonthPriceRunningSum = 0
            self.currentMonthNumTransactionsRunningCount = 0
            self.currentMonthHighestPrice = 0
            self.currentMonthLowestPrice = 0

            self.monthlyPastAveragePrices_5years = [0] * 60
            self.monthlyPastHighPrices_5years = [0] * 60
            self.monthlyPastLowPrices_5years = [0] * 60
            self.monthlyPastPricesStDev_5years = [0] * 60
            self.monthlyPastAvgVol_5years = [0] * 60

            lifeCycleCurveShapes = ["Traditional_1x", "Boom_classic_1x", "Fad_1x", "Revival_1x", "Extended_Fad_1x", "Seasonal_1x", "Bust_1x",
                                    "Traditional_2x", "Boom_classic_2x", "Fad_2x", "Revival_2x", "Extended_Fad_2x", "Seasonal_2x", "Bust_2x",
                                    "Traditional_3x", "Boom_classic_3x", "Fad_3x", "Revival_3x", "Extended_Fad_3x", "Seasonal_3x", "Bust_3x",
                                    "Traditional_4x", "Boom_classic_4x", "Fad_4x", "Revival_4x", "Extended_Fad_4x", "Seasonal_4x", "Bust_4x"]

            self.lifeCycleCurveShape = lifeCycleCurveShapes[lifeCycleCurveShapeID - 1]  # Adjusted for zero-based indexing in Python
            self.monthlyFairPrices_5years = tokenTypes_5Years_Expected_Prices[lifeCycleCurveShapeID - 1]  # Adjusted for zero-based indexing
    
    def __str__(self):
        return (f"Token ID: {self.tokenID}, Owner Agent ID: {self.ownerAgentID}\n"
                f"Current Buy Price: {self.currentBuyPrice}, Current Sell Price: {self.currentSellPrice}, Current Supply: {self.currentSupply}\n"
                f"Current Month Price Running Sum: {self.currentMonthPriceRunningSum}\n"
                f"Current Month Number of Transactions: {self.currentMonthNumTransactionsRunningCount}\n"
                f"Current Month Highest Price: {self.currentMonthHighestPrice}, Current Month Lowest Price: {self.currentMonthLowestPrice}\n"
                f"Monthly Past Average Prices (5 years): {self.monthlyPastAveragePrices_5years}\n"
                f"Monthly Past High Prices (5 years): {self.monthlyPastHighPrices_5years}\n"
                f"Monthly Past Low Prices (5 years): {self.monthlyPastLowPrices_5years}\n"
                f"Monthly Past Prices Standard Deviation (5 years): {self.monthlyPastPricesStDev_5years}\n"
                f"Monthly Past Average Volume (5 years): {self.monthlyPastAvgVol_5years}\n"
                f"Life Cycle Curve Shape: {self.lifeCycleCurveShape}\n"
                f"Monthly Fair Prices (5 years): {self.monthlyFairPrices_5years}")

# Example usage:
# tokenTypes_5Years_Expected_Prices = [[...], [...], ...]  # List of lists, one for each life cycle curve shape
# token = Token(tokenID=123, agentID=456, tokenTypes_5Years_Expected_Prices=tokenTypes_5Years_Expected_Prices, lifeCycleCurveShapeID=1)
