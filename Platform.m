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

        
   end
end