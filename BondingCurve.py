import math
class BondingCurve:

    def __init__(self, functionType, param1_m, param2_c, param3_n=None):
        self.functionType = functionType
        self.param1 = param1_m # m
        self.param2 = param2_c # c
        self.param3 = param3_n # n

        if self.functionType == "linear":
            self.buyFunction = lambda s, m, c, n=1: m * s + c
            self.sellFunction = lambda s, m, c, n=1: m * s + c
            self.deltaSupply = lambda s, m, c, costDeltaSupply: -((m * s + c) / (m ** 2)) + ((s + c / m) ** 2 + 2 * costDeltaSupply) ** 0.5
            self.costDeltaSupply = lambda s, m, c, deltaSupply, n=1: (m / 2) * (deltaSupply ** 2 + 2 * s * deltaSupply) + c * deltaSupply

        elif self.functionType == "polynomial":
            self.buyFunction = lambda s, m, c, n: m * s ** n + c
            self.sellFunction = lambda s, m, c, n: m * s ** n + c
            self.deltaSupply = None
            self.costDeltaSupply = lambda s, m, c, deltaSupply, n: (m / (n + 1)) * ((s + deltaSupply) ** (n + 1) - s ** (n + 1)) 

        elif self.functionType == "sigmoid":
            self.buyFunction = lambda s, c, c1, c2: c1*((s - c2)/math.sqrt((s-c2)**2 + c) + 1)  # Specify the buy function for the sigmoid curve
            self.sellFunction = lambda s, c, c1, c2: c1*((s - c2)/math.sqrt((s-c2)**2 + c) + 1)  # Specify the sell function for the sigmoid curve
            self.deltaSupply = None  # Specify the deltaSupply function for the sigmoid curve
            self.costDeltaSupply = lambda s, c, c1, c2, deltaSupply: c1*(math.sqrt((s+deltaSupply - c2)**2 + c) + s) -c1*(math.sqrt(c2**2 + c)) # Specify the costDeltaSupply function for the sigmoid curve

        elif self.functionType == "sublinear":
            self.buyFunction = None  # Specify the buy function for the sublinear curve
            self.sellFunction = None  # Specify the sell function for the sublinear curve
            self.deltaSupply = None  # Specify the deltaSupply function for the sublinear curve
            self.costDeltaSupply = None  # Specify the costDeltaSupply function for the sublinear curve

    # def costDeltaSupply(self, param1, param2, param3, param4):


# bonding_curve_obj = BondingCurve("linear", 5, 0, 0)
# print(bonding_curve_obj.sellFunction(1,2,3))