% this class defines the system parameters

classdef Platform
   properties
      buyFunc function_handle;
      sellFunc function_handle;
      transFee double;
   end

   methods
        function obj = Platform(buyFunc, sellFunc)
            if nargin > 0
                obj.buyFunc = buyFunc;
                obj.sellFunc = sellFunc;
            end
        end

        %  this function takes the number of tokens that the agent wants to buy, 
        %  computes the total price to be paid, and updates the current supply
        function [currentSupply, currentReserve] = mint(liquidity, buyFunc, currentSupply, deltaS, currentReserve)
            deltaR = integral(buyFunc, currentSupply, currentSupply+deltaS);
            if liquidity >= deltaR
                currentSupply = currentSupply + deltaS;
                currentReserve = currentReserve + deltaR;
            else
                currentSupply = currentSupply;
                currentReserve = currentReserve
            end
         end

         function [currentSupply, currentReserve] = burn(holdingVol, sellFunc, currentSupply, deltaS, currentReserve)
            deltaR = integral(sellFunc, currentSupply, currentSupply-deltaS);
            if holdingVol >= deltaR
                currentSupply = currentSupply - deltaS;
                currentReserve = currentReserve - deltaR;
            else
                currentSupply = currentSupply;
                currentReserve = currentReserve
            end
         end

   end
end