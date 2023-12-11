% this class defines the token parameters

classdef Token
   properties
      tokenID int64;
      ownerAgentID int64;
      
      initialPrice double;
      currentBuyPrice double;
      currentSellPrice double;
      currentSupply int64;
      lifeCycleCurveShape char; % any of the 28 token types based on their supply life cycle
      
      monthlyExpectedDiscountedPrices_5years(1,60) double; %For use by Fundy Agents, to be populated after birth of token
      
      monthlyPastAveragePrices_5years(1,60) double;
      monthlyPastHighPrices_5years(1,60) double;
      monthlyPastLowPrices_5years(1,60) double;
      monthlyPastPricesStDev_5years(1,60) double;
      monthlyPastAvgVol_5years(1,60) double;  % The above five indicators are to be used by Charty Agents, to be populated after birth of token until current month
   end

   methods
       function tokenObject = Token(tokenID, agentID, initPrice, currentBuyPrice, currentSellPrice, currentSupply, quality, ...
                monthlyExpectedDiscountedPrices_5years, monthlyPastAveragePrices_5years , monthlyPastHighPrices_5years , ...
                monthlyPastLowPrices_5years, monthlyPastPricesStDev_5years, monthlyPastAvgVol_5years)
            if nargin > 0
                tokenObject.tokenID = tokenID;
                tokenObject.ownerAgentID = agentID;
                tokenObject.initialPrice = initPrice;
                tokenObject.currentBuyPrice = currentBuyPrice;
                tokenObject.currentSellPrice = currentSellPrice;
                tokenObject.currentSupply = currentSupply;
                tokenObject.lifeCycleCurveShape = lifeCycleCurveShape;

                tokenObject.monthlyExpectedDiscountedPrices_5years = monthlyExpectedDiscountedPrices_5years;
                tokenObject.monthlyPastAveragePrices_5years = monthlyPastAveragePrices_5years;
                tokenObject.monthlyPastHighPrices_5years = monthlyPastHighPrices_5years;
                tokenObject.monthlyPastLowPrices_5years = monthlyPastLowPrices_5years;
                tokenObject.monthlyPastPricesStDev_5years = monthlyPastPricesStDev_5years;
                tokenObject.monthlyPastAvgVol_5years = monthlyPastAvgVol_5years;
            end
        end


   end
end