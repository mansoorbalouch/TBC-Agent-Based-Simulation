class BondingCurve:

    def __init__(self, functionType, param1, param2, param3=None):
        self.functionType = functionType
        self.param1 = param1
        self.param2 = param2
        self.param3 = param3

        if self.functionType == "linear":
            self.buyFunction = lambda s, m, c: m * s + c
            self.sellFunction = lambda s, m, c: m * s + c
            self.deltaSupply = lambda s, m, c, costDeltaSupply: -((m * s + c) / (m ** 2)) + ((s + c / m) ** 2 + 2 * costDeltaSupply) ** 0.5
            self.costDeltaSupply = lambda s, m, c, deltaSupply: (m / 2) * (deltaSupply ** 2 + 2 * s * deltaSupply) + c * deltaSupply

        elif self.functionType == "polynomial":
            self.buyFunction = lambda s, m, n, c: m * s ** n + c
            self.sellFunction = lambda s, m, n, c: m * s ** n + c
            self.deltaSupply = None
            self.costDeltaSupply = lambda s, m, n, c, costDeltaSupply: (m / (n + 1)) * ((s + costDeltaSupply) ** (n + 1) - s ** (n + 1)) 

        elif self.functionType == "sigmoid":
            self.buyFunction = None  # Specify the buy function for the sigmoid curve
            self.sellFunction = None  # Specify the sell function for the sigmoid curve
            self.deltaSupply = None  # Specify the deltaSupply function for the sigmoid curve
            self.costDeltaSupply = None  # Specify the costDeltaSupply function for the sigmoid curve

        elif self.functionType == "sublinear":
            self.buyFunction = None  # Specify the buy function for the sublinear curve
            self.sellFunction = None  # Specify the sell function for the sublinear curve
            self.deltaSupply = None  # Specify the deltaSupply function for the sublinear curve
            self.costDeltaSupply = None  # Specify the costDeltaSupply function for the sublinear curve


# bonding_curve_obj = BondingCurve("linear", 5, 0, 0)
# print(bonding_curve_obj.sellFunction(1,2,3))