import pkg.Agent.*


% create new agents and add to the agents list
function myAgents = createAgents(myAgents, agent)
%     create n agents with the proportion creators = 10%, investors = 20%, utilizers = 30%, and speculators = 40%
% assign strategies to the agents based on their category
% assign liquidity to each agent agent based on their category

        mu;
        std;
        randNumber = normrnd(mu,std,[1,100]);  
        %An investor agent has no riskAppetite, no proActiveness,
        %very likey to have fundamental strategy, 
        % The following assume that we have different normal
        % distributions to draw the risk appetite and proActiveness
        % for each type of agents by strategy 
        % type agent. The parameters of these normal distributions,
        % risk_mu_charty, risk_mu_charty, etc. are Platform variables

        if agentObject.purposeCategory == "creator"
            agentObject.riskAppetite = 0;
            agentObject.strategyType ="none";
            agentObject.proActiveness = 0;
        elseif agentObject.purposeCategory == "Investor"
            if randNumber <=.9
                agentObject.strategyType = "fundy";
                agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn(0,1); 
                agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn(0,1);
            elseif randNumber <=.98
                agentObject.strategyType = "charty";
                agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn(0,1); 
                agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(0,1);
            else
                agentObject.strategyType = "noisy";
                agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn(0,1);
                agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn(0,1);     
            end
        elseif agentObject.purposeCategory == "Utilizer"
            if randNumber <=.9
                agentObject.strategyType = "charty";
                agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn(0,1);
                agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(0,1);
            elseif randNumber <=.98
                agentObject.strategyType = "fundy";
                agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn(0,1);
                agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn(0,1);
            else
                agentObject.strategyType = "noisy";
                agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn(0,1);
                agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn(0,1);     
            end
        else %Speculator
            if randNumber <=.8
                agentObject.strategyType = "noisy";
                agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn(0,1);
                agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn(0,1);     
            elseif randNumber <=.98
                agentObject.strategyType = "charty";
                agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn(0,1);
                agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(0,1);
            else
                agentObject.strategyType = "fundy";
                agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn(0,1);
                agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn(0,1);
            end
        end

end
