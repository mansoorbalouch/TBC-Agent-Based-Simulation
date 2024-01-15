import math
from math import sqrt
from decimal import Decimal, getcontext

class BondingCurve:

    def __init__(self, functionType, param1, param2, param3=None):
        self.functionType = functionType
        """
        linear, polynomial & sublinear --- param1: m, param2: c, param3: n
        sigmoid --- param1: c, param2: a, param3: b 
        """

        # Setting the precision high enough to handle very large numbers
        getcontext().prec = 100
        
        self.param1 = param1 
        self.param2 = param2 
        self.param3 = param3 

        if self.functionType == "linear":
            self.buyFunction = lambda s, m, c, n=1: m * s + c
            self.sellFunction = lambda s, m, c, n=1: m * s + c
            self.deltaSupply = lambda s, m, c, costDeltaSupply, n=1: (-c - m*s + sqrt(c**2 + 2*c*m*s + m**2*s**2 + 2*m*costDeltaSupply))/m
            self.costDeltaSupply = lambda s, m, c, deltaSupply, n=1: (m / 2) * (deltaSupply ** 2 + 2 * s * deltaSupply) + c * deltaSupply

        elif self.functionType == "polynomial":
            self.buyFunction = lambda s, m, c, n: m * s ** n + c
            self.sellFunction = lambda s, m, c, n: m * s ** n + c
            self.deltaSupply = lambda s, m, c, costDeltaSupply, n: ((m*s**(n+1) + n*costDeltaSupply + costDeltaSupply)/m)**(1/(n+1)) - s
            self.costDeltaSupply = lambda s, m, c, deltaSupply, n: m / (n + 1) * ((s + deltaSupply) ** (n + 1) - s ** (n + 1)) # + c * deltaSupply
        
        elif self.functionType == "sublinear":
            self.buyFunction = lambda s, m, c, n: m*s**(1/n) 
            self.sellFunction = lambda s, m, c, n: m*s**(1/n) 
            self.deltaSupply = lambda s, m, c, costDeltaSupply, n: (s**((n+1)/n) + ((n+1)*costDeltaSupply)/(n*m))**(n/(n+1)) - s
            self.costDeltaSupply = lambda s, m, c, deltaSupply, n: n*m/(n+1) * ((s+deltaSupply)**((n+1)/n) - s**((n+1)/n))

        elif self.functionType == "sigmoid":
            self.buyFunction = lambda s, c, a, b: a*((s - b)/sqrt((s-b)**2 + c) + 1)  # c: steepness, a: x-axis inflection point, b: y-axis inflection point # s**2/16000 # 
            self.sellFunction = lambda s, c, a, b: a*((s - b)/sqrt((s-b)**2 + c) + 1)  # Specify the sell function for the sigmoid curve # s**2/16000 # 
            self.deltaSupply = lambda s, c, a, costDeltaSupply, b: costDeltaSupply*(2*a*c**(3/2)*sqrt((b**2 - 2*b*s + c + s**2)/c) + c*costDeltaSupply)/(2*a*(-a*b*c + a*c**(3/2)*sqrt((b**2 - 2*b*s + c + s**2)/c) + a*c*s + c*costDeltaSupply))
            self.costDeltaSupply = lambda s, c, a, deltaSupply, b: a*(sqrt((s+deltaSupply - b)**2 + c) - (sqrt( (s-b)**2 + c)) + deltaSupply )


    # def costDeltaSupply(self, param1, param2, param3, param4):


# bonding_curve_obj = BondingCurve("linear", 5, 0, 0)
# print(bonding_curve_obj.sellFunction(1,2,3))