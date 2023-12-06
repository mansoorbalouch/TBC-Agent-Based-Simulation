classdef Agent
   properties
      agentID;
      liquidity;
      holdings;
      type;
   end

   methods
       function mint(liquidity, buyFunc, currentSupply, deltaS)
%            buyFunc = @(s) buyFunc
            deltaR = integral(buyFunc, currentSupply, currentSupply+deltaS)
            if liquidity >= deltaR
                currentSupply = currentSupply + deltaS
            else
                print("Insufficient liquidity..")
            end
         end

         function burn(sellFunc, currentSupply, deltaS)
            deltaR = integral(sellFunc, currentSupply, currentSupply-deltaS)
            if liquidity >= deltaR
                currentSupply = currentSupply - deltaS
            else
                print("Insufficient liquidity..")
            end
         end
   end
end