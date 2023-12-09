%  this platform function takes the number of tokens that the agent wants to buy, 
%  computes the total price to be paid, and updates the current supply

 function [currentSupply, currentReserve] = burn(holdingVol, sellFunc, currentSupply, deltaS, currentReserve)
    deltaR = integral(sellFunc, currentSupply, currentSupply-deltaS);
    if holdingVol >= deltaR
        currentSupply = currentSupply - deltaS;
        currentReserve = currentReserve - deltaR;
    else
        currentSupply = currentSupply;
        currentReserve = currentReserve;
    end
 end

