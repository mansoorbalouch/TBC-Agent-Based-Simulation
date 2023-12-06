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
       
        function fundPrice = compFundPrice(agent, currentPrice, currentSupply)
           
           if agent.type == "Fundy"
                fundPrice =  currentPrice + 10;
                
            elseif agent.type == "Charty"
                fundPrice = currentPrice + 5;
                
            elseif agent.type == "Noisy"
                fundPrice =  abs(currentPrice - 10);
           else
               fundPrice = currentPrice;
           end
           return
       end

       function myAgents = createAgent(myAgents, agent)
            myAgents = [myAgents, agent];
          
       end
   end
end