% each agent type compute it's fundamental price
function estPrice = estPrice(agent, currentPrice, currentSupply)
    if agent.purpClass == "creator"       
        if agent.type == "Fundy"
            estPrice = compFundPrice();
        elseif agent.type == "Charty"
              estPrice = compEstPrice();          
        elseif agent.type == "Noisy"
           estPrice = compPrice();
       else
           estPrice = currentPrice;
        end

    elseif agent.purpClass == "investor"
        if agent.type == "Fundy"
            estPrice = compFundyPrice();
        elseif agent.type == "Charty"
              estPrice = compChartyPrice();          
        elseif agent.type == "Noisy"
           estPrice = compNoisyPrice();
       else
           estPrice = currentPrice;
        end

    elseif agent.purpClass == "speculator"
        if agent.type == "Fundy"
            estPrice = compFundyPrice();
        elseif agent.type == "Charty"
              estPrice = compChartyPrice();          
        elseif agent.type == "Noisy"
           estPrice = compNoisyPrice();
       else
           estPrice = currentPrice;
        end

    elseif agent.purpClass == "utilizer"
        if agent.type == "Fundy"
            estPrice = compFundyPrice();
        elseif agent.type == "Charty"
              estPrice = compChartyPrice();          
        elseif agent.type == "Noisy"
           estPrice = compNoisyPrice();
       else
           estPrice = currentPrice;
        end
    
    end
end


function fundPrice = compFundyPrice()
   cashFlow;
   discountRate;
    % f = @(t) cashFlow_t
    % fundPrice =  symsum(f,t,0,n)
    fundPrice;
    estPrice = fundPrice;
end


function estPrice = compChartyPrice()
    estPrice= currentPrice + 5;
end

function estPrice = compNoisyPrice()
     estPrice =  abs(currentPrice - 10);
end

