
%  this platform function takes the number of tokens that the agent wants to buy, 
%  computes the total price to be paid, and updates the current supply
function [currentSupply, currentReserve] = mint(liquidity, buyFunc, currentSupply, deltaS, currentReserve)
    deltaR = integral(buyFunc, currentSupply, currentSupply+deltaS);
    if liquidity >= deltaR
        currentSupply = currentSupply + deltaS;
        currentReserve = currentReserve + deltaR;
    else
        currentSupply = currentSupply;
        currentReserve = currentReserve;
    end
    return
 end
