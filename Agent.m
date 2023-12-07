classdef Agent
   properties
      agentID int64;
      liquidity double;
      holdings double;
      holdingVol double;
      type char;
   end

   methods
       function obj = Agent(agentID, liquidity, holdings, holdingVol, type)
            if nargin > 0
                obj.agentID = agentID;
                obj.liquidity = liquidity;
                obj.holdings = holdings;
                obj.holdingVol = holdingVol;
                obj.type = type;
            end
        end
       
   end
end