import numpy as np

class Agent:
    def __init__(self, agentID=None, purpClass=None, DoB=None, ownTokenId=None):
        self.risk_mu_fundy = 0.20
        self.risk_sigma_fundy = 0.03
        self.risk_mu_charty = 0.40
        self.risk_sigma_charty = 0.05
        self.risk_mu_noisy = 0.60
        self.risk_sigma_noisy = 0.10

        self.activity_mu_fundy = 0.15
        self.activity_sigma_fundy = 0.04
        self.activity_mu_charty = 0.35
        self.activity_sigma_charty = 0.09
        self.activity_mu_noisy = 0.50
        self.activity_sigma_noisy = 0.07

        self.midClass_mu_liquidity = 5000
        self.midClass_sigma_liquidity = 500
        self.rich_mu_liquidity = 10000
        self.rich_sigma_liquidity = 1000
        self.poor_mu_liquidity = 2000
        self.poor_sigma_liquidity = 300

        self.intelligencegap_mu_fundy = 0.20
        self.intelligencegap_sigma_fundy = 0.05

        self.numTermsForeseen_mu_fundy = 7
        self.numTermsForeseen_sigma_fundy = 1
        self.numHindsightTerms_mu_Charty = 7
        self.numHindsightTerms_sigma_Charty = 1

        self.creator_mu_DayOfPassing = 36
        self.creator_sigma_DayOfPassing = 3
        self.rich_mu_DayOfPassing = 48
        self.rich_sigma_DayOfPassing = 3
        self.midClass_mu_DayOfPassing = 24
        self.midClass_sigma_DayOfPassing = 3
        self.poor_mu_DayOfPassing = 12
        self.poor_sigma_DayOfPassing = 2

        self.agentID = agentID
        self.purposeCategory = purpClass
        self.dayOfBirth = DoB
        self.intelligenceGap = 0
        self.ownTokenId = ownTokenId

        self.numTermsForeseen_Fundy = 0
        self.monthlyWeights4ExpPrice_Fundy = []
        self.numHindsightTerms_Charty = 0
        self.monthlyWeights4MvngAvg_Charty = []
        self.currentMonthAllTokensExpectedPrices_Fundy = []

        self.tokenHoldings = dict()
        # self.tokenHoldingsIDs = []
        # self.tokenHoldingsValues = []

        randNumber = np.random.rand()

        if self.purposeCategory == "creator":
            self.strategyType = "none"
            self.riskAppetite = 0
            self.proActiveness = 0
            self.liquidity = 0
            self.dayOfPassing = int(DoB + abs(np.random.normal(self.creator_mu_DayOfPassing, self.creator_sigma_DayOfPassing)))
        elif self.purposeCategory == "Investor":
            if randNumber <= .9:
                self.strategyType = "fundy"
            elif randNumber <= .98:
                self.strategyType = "charty"
            else:
                self.strategyType = "noisy"
            self.liquidity = np.random.normal(self.rich_mu_liquidity, self.rich_sigma_liquidity)
            self.dayOfPassing = int(abs(DoB + np.random.normal(self.rich_mu_DayOfPassing, self.rich_sigma_DayOfPassing)))
        elif self.purposeCategory == "Utilizer":
            if randNumber <= .9:
                self.strategyType = "charty"
            elif randNumber <= .98:
                self.strategyType = "fundy"
            else:
                self.strategyType = "noisy"
            self.liquidity = np.random.normal(self.midClass_mu_liquidity, self.midClass_sigma_liquidity)
            self.dayOfPassing = int(abs(DoB + np.random.normal(self.midClass_mu_DayOfPassing, self.midClass_sigma_DayOfPassing)))
        else:  # Speculator
            if randNumber <= .8:
                self.strategyType = "noisy"
            elif randNumber <= .98:
                self.strategyType = "charty"
            else:
                self.strategyType = "fundy"
            self.liquidity = np.random.normal(self.poor_mu_liquidity, self.poor_sigma_liquidity)
            self.dayOfPassing = int(abs(DoB + np.random.normal(self.poor_mu_DayOfPassing, self.poor_sigma_DayOfPassing)))

        # Set strategies and other parameters
        if self.strategyType == "fundy":
            self.riskAppetite = np.random.normal(self.risk_mu_fundy, self.risk_sigma_fundy)
            self.riskAppetite = max(0.0001, min(self.riskAppetite, 0.9999))
            self.proActiveness = np.random.normal(self.activity_mu_fundy, self.activity_sigma_fundy)
            self.proActiveness = max(0.0001, min(self.proActiveness, 0.9999))
            self.intelligenceGap = np.random.normal(self.intelligencegap_mu_fundy, self.intelligencegap_sigma_fundy)
            self.numTermsForeseen_Fundy = int(np.random.normal(self.numTermsForeseen_mu_fundy, self.numTermsForeseen_sigma_fundy))
            if self.numTermsForeseen_Fundy <=0:
                self.numTermsForeseen_Fundy =1
            elif  self.numTermsForeseen_Fundy >10:
                self.numTermsForeseen_Fundy =10
            terms = np.arange(1, self.numTermsForeseen_Fundy + 1)
            self.monthlyWeights4ExpPrice_Fundy = 1 / terms
            self.monthlyWeights4ExpPrice_Fundy /= self.monthlyWeights4ExpPrice_Fundy.sum()
        elif self.strategyType == "charty":
            self.riskAppetite = np.random.normal(self.risk_mu_charty, self.risk_sigma_charty)
            self.riskAppetite = max(0.0001, min(self.riskAppetite, 0.9999))
            self.proActiveness = np.random.normal(self.activity_mu_charty, self.activity_sigma_charty)
            self.proActiveness = max(0.0001, min(self.proActiveness, 0.9999))
            self.numHindsightTerms_Charty = int(np.random.normal(self.numHindsightTerms_mu_Charty, self.numHindsightTerms_sigma_Charty))
            if self.numHindsightTerms_Charty <=0:
                self.numHindsightTerms_Charty =1
            elif  self.numHindsightTerms_Charty >10:
                self.numHindsightTerms_Charty =10
            terms = np.arange(1, self.numHindsightTerms_Charty + 1)
            self.monthlyWeights4MvngAvg_Charty = 1 / terms
            self.monthlyWeights4MvngAvg_Charty /= self.monthlyWeights4MvngAvg_Charty.sum()
        elif self.strategyType == "noisy":
            self.riskAppetite = np.random.normal(self.risk_mu_noisy, self.risk_sigma_noisy)
            self.riskAppetite = max(0.0001, min(self.riskAppetite, 0.9999))
            self.proActiveness = np.random.normal(self.activity_mu_noisy, self.activity_sigma_noisy)
            self.proActiveness = max(0.0001, min(self.proActiveness, 0.9999))

    def __str__(self):
        return (
            f"Agent ID: {self.agentID}\n"
            f"Purpose Category: {self.purposeCategory}\n"
            f"Strategy Type: {self.strategyType}\n"
            f"Liquidity: {self.liquidity}\n"
            f"Token Holdings: {self.tokenHoldings}\n"
            f"Risk Appetite: {self.riskAppetite}\n"
            f"Pro Activeness: {self.proActiveness}\n"
            f"Intelligence Gap: {self.intelligenceGap}\n"
            f"Own Token ID: {self.ownTokenId}\n"
            f"Day of Birth: {self.dayOfBirth}\n"
            f"Day of Passing: {self.dayOfPassing}\n"
            f"Num Terms Foreseen (Fundy): {self.numTermsForeseen_Fundy}\n"
            f"Num Hindsight Terms (Charty): {self.numHindsightTerms_Charty}\n"
            f"Monthly Weights (Charty): {self.monthlyWeights4MvngAvg_Charty}\n"
            f"Monthly Weights (Fundy): {self.monthlyWeights4ExpPrice_Fundy}\n"
            f"Current Month Tokens Expected Prices (Fundy):{self.currentMonthAllTokensExpectedPrices_Fundy}\n-------------------------------\n"
        )
# Example usage:
# plateParamsDict = {'creator_mu_DayOfPassing': 3, 'creator_sigma_DayOfPassing': 1, ...}
# agent = Agent(agentID=123, purpClass="Investor", DoB=20210101, ownTokenId=456, plateParams=plateParamsDict)