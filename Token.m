% this class defines the token parameters

classdef Token
   properties
      tokenID int64;
      agentID int64;
      currentPrice double;
      currentSupply int64;
      currentReserve double;
   end

   methods
       function obj = Token(tokenID, currentPrice, currentSupply,currentReserve)
            if nargin > 0
                obj.tokenID = tokenID;
                obj.currentPrice = currentPrice;
                obj.currentSupply = currentSupply;
                obj.currentReserve = currentReserve;
            end
        end


   end
end