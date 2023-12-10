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
        function agentObject = Agent(agentID, purpClass, holdings, ownTokenId, DoB, DoD, noTermsForeseen_Fundy,dailyWeights4MvngAvg_Charty)
            if nargin > 0
                agentObject.agentID = agentID;
                agentObject.purposeCategory = purpClass;
                agentObject.holdings = holdings;
                agentObject.strategyType = stratType;
                agentObject.dayOfBirth = DoB;
                agentObject.dayOfPassing = DoD;


                agentObject.ownTokenId = ownTokenId;
                
                agentObject.numTermsForeseen_Fundy = noTermsForeseen_Fundy;
                agentObject.dailyWeights4MvngAvg_Charty = dailyWeights4MvngAvg_Charty;
                
                randNumber = rand();
                
                %An investor agent has no riskAppetite, no proActiveness,
                %very likey to have fundamental strategy,
                % The following assume that we have different normal
                % distributions to draw the risk appetite and proActiveness
                % for each type of agents by strategy
                % type agent. The parameters of these normal distributions,
                % risk_mu_charty, risk_mu_charty, poor_mu_liquidity, etc. are Platform variables

                if agentObject.purposeCategory == "creator"
                    agentObject.riskAppetite = 0;
                    agentObject.strategyType ="none";
                    agentObject.proActiveness = 0;
                    agentObject.liquidity = 0;
                elseif agentObject.purposeCategory == "Investor"
                    if randNumber <=.9
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn;
                        agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn;
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn;
                        agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(1);
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn;
                        agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn;
                    end
                    agentObject.liquidity = rich_mu_liquidity + rich_sigma_liquidity* randn();
                elseif agentObject.purposeCategory == "Utilizer"
                    if randNumber <=.9
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn(1);
                        agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(1);
                    elseif randNumber <=.98
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn(1);
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn(1);
                    end
                    agentObject.liquidity = midClass_mu_liquidity + midClass_sigma_liquidity* randn();
                else %Speculator
                    if randNumber <=.8
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = risk_mu_noisy + risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = activity_mu_noisy + activity_sigma_noisy * randn(1);
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = risk_mu_charty + risk_sigma_charty * randn(1);
                        agentObject.proActiveness = activity_mu_charty + activity_sigma_charty * randn(1);
                    else
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = risk_mu_fundy + risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = activity_mu_fundy + activity_sigma_fundy * randn(1);
                    end
                    agentObject.liquidity = poor_mu_liquidity + poor_sigma_liquidity* randn();
                    
                end


            end
        end
    end
end
