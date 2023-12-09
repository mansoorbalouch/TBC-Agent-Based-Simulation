classdef Agent
   properties
      agentID int64;
      purposeCategory char;  %could be either "Creator", "Investor", "Utilizer", or "Speculator" 
      liquidity double;
      % holdings contain number of tokens held by this agent as key value pair
      holdings(2,:) int64;
      strategyType char;
      riskAppetite double;
      proActiveness double;
      ownTokenId int64;
      dayOfBirth int16;
      dayOfPassing int16;
      numTermsForeseen_Fundy  int16;
      dailyWeights4MvngAvg_Charty(1,:) double;
        
   end

   methods
       function agentObject = Agent(agentID,purpClass, liquidity, holdings,stratType, ownTokenId, noTermsForeseen_Fundy,dailyWeights4MvngAvg_Charty)
            if nargin > 0
                agentObject.agentID = agentID;
                agentObject.purposeCategory = purpClass;
                agentObject.liquidity = liquidity;
                agentObject.holdings = holdings;
                agentObject.strategyType = stratType;
                
                %agentObject.riskAppetite = risk;
                %agentObject.proActiveness = activity;
                agentObject.ownTokenId = ownTokenId;
                agentObject.numTermsForeseen_Fundy = noTermsForeseen_Fundy;
                agentObject.dailyWeights4MvngAvg_Charty = dailyWeights4MvngAvg_Charty;

              
            end
        end
       
   end
end