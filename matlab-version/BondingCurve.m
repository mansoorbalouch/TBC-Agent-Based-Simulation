classdef BondingCurve
    properties
        functionType string;
        buyFunction function_handle;
        sellFunction function_handle;
        deltaSupply function_handle;
        costDeltaSupply function_handle;
        param1 double;
        param2 double;
        param3 double;

    end

    methods 
        function BondingCurveObj = BondingCurve(functionType, param1, param2, param3)
            if nargin > 0  
                BondingCurveObj.functionType = functionType;

                if BondingCurveObj.functionType == "linear"
                    BondingCurveObj.param1 = param1;
                    BondingCurveObj.param2 = param2;
                    BondingCurveObj.param3 = param3;
                    BondingCurveObj.buyFunction = @(s, m, c) m * s + c;
                    BondingCurveObj.sellFunction = @(s, m, c) m * s + c;
                    BondingCurveObj.deltaSupply = @(s, m, c, costDeltaSupply) - (m*s+c)/m^2 + sqrt((s+c/m)^2 + 2*costDeltaSupply);
                    BondingCurveObj.costDeltaSupply = @(s, m, c, deltaSupply) m/2 * (deltaSupply^2 + 2*s*deltaSupply) + c*deltaSupply ;
                
                elseif BondingCurveObj.functionType == "polynomial"
                    BondingCurveObj.param1 = param1;
                    BondingCurveObj.param2 = param2;
                    BondingCurveObj.param3 = param3;
                    BondingCurveObj.buyFunction = @(s, m, n, c) m * s^n + c;
                    BondingCurveObj.sellFunction =@(s, m, n, c) m * s^n + c;
                    BondingCurveObj.deltaSupply = deltaSupply;
                    BondingCurveObj.costDeltaSupply = @(s, m, n, c, deltaSupply) m/(n+1) * (s + deltaSupply)^(n+1) - m/(n+1) * s^(n+1);
                    
                elseif BondingCurveObj.functionType == "sigmoid"
                    BondingCurveObj.buyFunction = @(s,c1,c2,c) c1 * ((s-c2)/(sqrt((s-c2)^2 + c)) + 1);
                    BondingCurveObj.sellFunction = @(s,c1,c2,c) c1 * ((s-c2)/(sqrt((s-c2)^2 + c)) + 1);
                    BondingCurveObj.deltaSupply = deltaSupply;
                    BondingCurveObj.costDeltaSupply = @(s,c1,c2,c, deltaSupply) c1 * (sqrt((s + deltaSupply - c2)^2 + c) + s) - c1 * (sqrt(c2^2 + c)) ;

                elseif functionType == "sublinear"

                end

            end
        end

    end
end

