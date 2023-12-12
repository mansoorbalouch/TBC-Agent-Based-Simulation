% this class defines the token parameters

classdef Token
   properties
      tokenID int64;
      ownerAgentID int64;
      
%       initialPrice double;
      currentBuyPrice double;
      currentSellPrice double;
      currentSupply double;
      lifeCycleCurveShape string; % any of the 28 token supply cycles
      
      monthlyExpectedDiscountedPrices_5years(1,:) double; %For use by Fundy Agents, to be populated after birth of token
      
      monthlyPastAveragePrices_5years(1,:) double;
      monthlyPastHighPrices_5years(1,:) double;
      monthlyPastLowPrices_5years(1,:) double;
      monthlyPastPricesStDev_5years(1,:) double;
      monthlyPastAvgVol_5years(1,:) double;  % The above five indicators are to be used by Charty Agents, to be populated after birth of token until current month
   end

   methods
       function tokenObject = Token(tokenID, agentID, currentBuyPrice, currentSellPrice, currentSupply, ...
                monthlyPastAveragePrices_5years , monthlyPastHighPrices_5years , ...
                monthlyPastLowPrices_5years, monthlyPastPricesStDev_5years, monthlyPastAvgVol_5years)
            if nargin > 0
                tokenObject.tokenID = tokenID;
                tokenObject.ownerAgentID = agentID;
%                 tokenObject.initialPrice = initPrice;
                tokenObject.currentBuyPrice = currentBuyPrice;
                tokenObject.currentSellPrice = currentSellPrice;
                tokenObject.currentSupply = currentSupply;

                tokenObject.monthlyPastAveragePrices_5years = monthlyPastAveragePrices_5years;
                tokenObject.monthlyPastHighPrices_5years = monthlyPastHighPrices_5years;
                tokenObject.monthlyPastLowPrices_5years = monthlyPastLowPrices_5years;
                tokenObject.monthlyPastPricesStDev_5years = monthlyPastPricesStDev_5years;
                tokenObject.monthlyPastAvgVol_5years = monthlyPastAvgVol_5years;

                lifeCycleCurveShapes = ["Traditional_1x","Boom_1x","Fad_1x","Revival_1x","ExtendedFad_1x","Seasonal_1x","Bust_1x", ...
                    "Traditional_2x","Boom_2x","Fad_2x","Revival_2x","ExtendedFad_2x","Seasonal_2x","Bust_2x", ...
                    "Traditional_3x","Boom_3x","Fad_3x","Revival_3x","ExtendedFad_3x","Seasonal_3x","Bust_3x", ...
                    "Traditional_4x","Boom_4x","Fad_4x","Revival_4x","ExtendedFad_4x","Seasonal_4x","Bust_4x",];

                tokenObject.lifeCycleCurveShape = randsample(lifeCycleCurveShapes,1);
                tblMonthlyExpectedDiscountedPrices_5years = readtable("monthlyExpectedDiscountedPrices_5years.csv");
                tokenObject.monthlyExpectedDiscountedPrices_5years = tblMonthlyExpectedDiscountedPrices_5years.lifeCycleCurveShape;
                
            end
        end


   end
end