% this class defines the system parameters

classdef Platform
   properties
      fundPrice;
      buyFunc;
      sellFunc;
      
   end

   methods
       function compFundPrice(a, buy_func, s0, deltaS)
           
           if a.type == "Fundy"
            fundPrice;
            currentPrice;
            if fundPrice > currentPrice
                mint(100, buyFunc, 20, 50)
            elseif fundPrice < currentPrice
                burn(100, sellFunc, 20, 50)
            end
            return
        elseif a.type =="Charty"
            fundPrice;
            currentPrice;
            if fundPrice > currentPrice
                mint(100, buyFunc, 20, 50)
            elseif fundPrice < currentPrice
                burn(100, sellFunc, 20, 50)
            end
            return
        elseif a.type == "Noise"
            fundPrice;
            currentPrice;
            if fundPrice > currentPrice
                mint(100, buyFunc, 20, 50)
            elseif fundPrice < currentPrice
                burn(100, sellFunc, 20, 50)
            end
            return
        end


         end

   end
end