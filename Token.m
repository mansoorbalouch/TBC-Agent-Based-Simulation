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
      
      monthlyExpectedFairPrices_5years(1,:) double; %For use by Fundy Agents, to be populated after birth of token

      monthlyPriceRunningSum double;
      monthlyNumTransactionsRunningSum int16;
      monthlyHighestPrice int16;
      monthlyLowestPrice int16;
      
      monthlyPastAveragePrices_5years(1,:) double;
      monthlyPastHighPrices_5years(1,:) double;
      monthlyPastLowPrices_5years(1,:) double;
      monthlyPastPricesStDev_5years(1,:) double;
      monthlyPastAvgVol_5years(1,:) double;  % The above five indicators are to be used by Charty Agents, to be populated after birth of token until current month


   end

   methods
       function tokenObject = Token(tokenID, agentID, tokenTypes_5Years_Expected_Prices, lifeCycleCurveShapeID)
            if nargin > 0
                tokenObject.tokenID = tokenID;
                tokenObject.ownerAgentID = agentID;
%                 tokenObject.initialPrice = initPrice;
                tokenObject.currentBuyPrice = 0;
                tokenObject.currentSellPrice = 0;
                tokenObject.currentSupply = 0;

                tokenObject.monthlyPriceRunningSum = 0;
                tokenObject.monthlyNumTransactionsRunningSum = 0;
                tokenObject.monthlyHighestPrice  = 0;
                tokenObject.monthlyLowestPrice = 0;

                tokenObject.monthlyPastAveragePrices_5years = zeros([1,60]);
                tokenObject.monthlyPastHighPrices_5years = zeros([1,60]);
                tokenObject.monthlyPastLowPrices_5years = zeros([1,60]);
                tokenObject.monthlyPastPricesStDev_5years = zeros([1,60]);
                tokenObject.monthlyPastAvgVol_5years = zeros([1,60]);

                lifeCycleCurveShapes = ["Traditional_1x","Boom_classic_1x","Fad_1x","Revival_1x","Extended_Fad_1x","Seasonal_1x","Bust_1x", ...
                    "Traditional_2x","Boom_classic_2x","Fad_2x","Revival_2x","Extended_Fad_2x","Seasonal_2x","Bust_2x", ...
                    "Traditional_3x","Boom_classic_3x","Fad_3x","Revival_3x","Extended_Fad_3x","Seasonal_3x","Bust_3x", ...
                    "Traditional_4x","Boom_classic_4x","Fad_4x","Revival_4x","Extended_Fad_4x","Seasonal_4x","Bust_4x",];

                tokenObject.lifeCycleCurveShape = lifeCycleCurveShapes(lifeCycleCurveShapeID);
                tokenObject.monthlyExpectedFairPrices_5years = tokenTypes_5Years_Expected_Prices(:,lifeCycleCurveShapeID);
%                 tokenObject.monthlyExpectedDiscountedPrices_5years = rand(1,60);
                
            end
        end


   end
end