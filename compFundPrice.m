% each agent type compute it's fundamental price
function fundPrice = compFundPrice(agent, currentPrice, currentSupply)
   
   if agent.type == "Fundy"
       cashFlow;
       discountRate;
        % f = @(t) cashFlow_t
        % fundPrice =  symsum(f,t,0,n)
        
    elseif agent.type == "Charty"
        fundPrice = currentPrice + 5;
        
    elseif agent.type == "Noisy"
        fundPrice =  abs(currentPrice - 10);
   else
       fundPrice = currentPrice;
   end
   return
end
