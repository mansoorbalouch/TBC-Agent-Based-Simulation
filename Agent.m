classdef Agent
    properties
        agentID int64;
        purposeCategory string;  %could be either "Creator", "Investor", "Utilizer", or "Speculator"
        strategyType string;
        liquidity double;
        % holdings contain number of tokens held by this agent as key value pair
        tokenHoldingsIDs(1,:) int64;
        tokenHoldingsValues(1,:) double;
        riskAppetite int16; % between 0 and 100
        proActiveness int16; 
        intelligenceGap double;
        ownTokenId int64;
        dayOfBirth int16;
        dayOfPassing int16;
        numTermsForeseen_Fundy int16;
        numHindsightTerms_Charty int16;
        monthlyWeights4MvngAvg_Charty(1,60) double;
        monthlyWeights4ExpPrice_Fundy(1,60) double;

    end

    methods
        function agentObject = Agent(agentID, purpClass,DoB, ownTokenId, plateParams)
            if nargin > 0
                agentObject.agentID = agentID;
                agentObject.purposeCategory = purpClass;
                agentObject.dayOfBirth = DoB;
                agentObject.intelligenceGap = 0;
                agentObject.ownTokenId = ownTokenId;
                
                agentObject.numTermsForeseen_Fundy = 0;
                agentObject.monthlyWeights4MvngAvg_Charty = zeros([1,60]);
                agentObject.numHindsightTerms_Charty = 0;
                agentObject.monthlyWeights4ExpPrice_Fundy = zeros([1,60]);

                agentObject.tokenHoldingsIDs = [];
                agentObject.tokenHoldingsValues = [];
                
                randNumber = rand();
                
                %An investor agent has no riskAppetite, no proActiveness,
                %very likey to have fundamental strategy,
                % The following assume that we have different normal
                % distributions to draw the risk appetite and proActiveness
                % for each type of agents by strategy
                % type agent. The parameters of these normal distributions,
                % risk_mu_charty, risk_mu_charty, poor_mu_liquidity, etc. are plateParams variables

                if agentObject.purposeCategory == "creator"
                    agentObject.riskAppetite = 0;
                    agentObject.strategyType ="none";
                    agentObject.proActiveness = 0;
                    agentObject.liquidity = 0;
                    agentObject.dayOfPassing = DoB + plateParams.creator_mu_DayOfPassing + plateParams.creator_sigma_DayOfPassing * randn; % average age = 3 year

                elseif agentObject.purposeCategory == "Investor"
                    if randNumber <=.9
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn;
                        agentObject.proActiveness = plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn;
                        agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn;
                        weights = normalize(rand(1,agentObject.numTermsForeseen_Fundy),2);
                        for term=1:agentObject.numTermsForeseen_Fundy
                            agentObject.monthlyWeights4ExpPrice_Fundy(1, term) = weights(1,term);
                        end
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn;
                        agentObject.proActiveness = plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn(1);
                        agentObject.numHindsightTerms_Charty = plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn;
                        weights = normalize(rand(1,agentObject.numHindsightTerms_Charty),2);
                        for term=1:agentObject.numHindsightTerms_Charty
                            agentObject.monthlyWeights4MvngAvg_Charty(1, term) = weights(1,term);
                        end
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn;
                        agentObject.proActiveness = plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn;
                    end
                    agentObject.liquidity = plateParams.rich_mu_liquidity + plateParams.rich_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + plateParams.rich_mu_DayOfPassing + plateParams.rich_sigma_DayOfPassing* randn(); % average age = 4 years
                elseif agentObject.purposeCategory == "Utilizer"
                    if randNumber <=.9
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn(1);
                        agentObject.numHindsightTerms_Charty = plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn;
                        weights = normalize(rand(1,agentObject.numHindsightTerms_Charty),2);
                        for term=1:agentObject.numHindsightTerms_Charty
                            agentObject.monthlyWeights4MvngAvg_Charty(1, term) = weights(1,term);
                        end
                    elseif randNumber <=.98
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn(1);
                        agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn;
                        weights = normalize(rand(1,agentObject.numTermsForeseen_Fundy),2); % initialize weights and normalize
                        for term=1:agentObject.numTermsForeseen_Fundy
                            agentObject.monthlyWeights4ExpPrice_Fundy(1, term) = weights(1,term);
                        end
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn(1);
                    end
                    agentObject.liquidity = plateParams.midClass_mu_liquidity + plateParams.midClass_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + plateParams.midClass_mu_DayOfPassing + plateParams.midClass_sigma_DayOfPassing* randn(); % average age = 2 years
                else %Speculator
                    if randNumber <=.8
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn(1);
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn(1);
                        agentObject.numHindsightTerms_Charty = plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn;
                        weights = normalize(rand(1,agentObject.numHindsightTerms_Charty),2);
                        for term=1:agentObject.numHindsightTerms_Charty
                            agentObject.monthlyWeights4MvngAvg_Charty(1, term) = weights(1,term);
                        end
                    else
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn(1);
                        agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn;
                        weights = normalize(rand(1,agentObject.numTermsForeseen_Fundy),2);
                        for term=1:agentObject.numTermsForeseen_Fundy
                            agentObject.monthlyWeights4ExpPrice_Fundy(1, term) = weights(1,term);
                        end
                    end
                    agentObject.liquidity = plateParams.poor_mu_liquidity + plateParams.poor_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + plateParams.poor_mu_DayOfPassing + plateParams.poor_sigma_DayOfPassing* randn(); % average age = 1 year
                    
                end


            end
        end
    end
end
