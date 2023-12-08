% this class defines the token parameters

classdef Token
   properties
      tokenID int64;
      agentID int64;
      currentPrice double;
      currentSupply int64;
      currentReserve double;
      quality int64;
   end

   methods
       function obj = Token(tokenID, currentPrice, currentSupply, currentReserve, ...
               quality)
            if nargin > 0
                obj.tokenID = tokenID;
                obj.currentPrice = currentPrice;
                obj.currentSupply = currentSupply;
                obj.currentReserve = currentReserve;
                obj.quality = quality;
            end
        end


   end
end