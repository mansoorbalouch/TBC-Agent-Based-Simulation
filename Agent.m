classdef Agent
   properties
      agentID int64;
      purpClass char;
      liquidity double;
      % supply holdings and reserve volumes of n tokens
      holdings(2,:) int64;
      holdingVol(2,:) double;
      stratType char;
      risk double;
      activity double;
   end

   methods
       function obj = Agent(agentID,purpClass, liquidity, holdings, holdingVol, ...
               stratType, risk, activity)
            if nargin > 0
                obj.agentID = agentID;
                obj.purpClass = purpClass;
                obj.liquidity = liquidity;
                obj.holdings = holdings;
                obj.holdingVol = holdingVol;
                obj.stratType = stratType;
                obj.risk = risk;
                obj.activity = activity;
            end
        end
       
   end
end