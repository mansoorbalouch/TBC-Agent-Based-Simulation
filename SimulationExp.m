import pkg.Agent.*
import pkg.Token.*
import pkg.Platform.*

simSteps = 200;
numAgents = 100;

buyFunc = @(s) 2*s;
sellFunc = @(s) 1.5*s;

myAgents = [Agent]

for t=1:simSteps
%     select the active agents for t
%      return the IDs of the active agents in matrix a
    a = Agent;
    numActAgents = length(a)
    for i=1:numActAgents
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
           
