classdef Agent
    properties
        agentID int64;
        purposeCategory string;  %could be either "Creator", "Investor", "Utilizer", or "Speculator"
        strategyType string;
        liquidity double;
        % holdings contain number of tokens held by this agent as key value pair
        holdings(2,:) int64;
        riskAppetite double;
        proActiveness double;
        intelligenceGap double;
        ownTokenId int64;
        dayOfBirth int16;
        dayOfPassing int16;
        numTermsForeseen_Fundy  int16;
        dailyWeights4MvngAvg_Charty(1,60) double;

    end

    methods
        function agentObject = Agent(purpClass,DoB, Platform)
            if nargin > 0
%                 agentObject.agentID = agentID;
                agentObject.purposeCategory = purpClass;
%                 agentObject.strategyType = strategyType;
%                 agentObject.holdings = holdings;
                agentObject.dayOfBirth = DoB;
%                 agentObject.dayOfPassing = DoD;
                agentObject.intelligenceGap = 0;


%                 agentObject.ownTokenId = ownTokenId;
                
                agentObject.numTermsForeseen_Fundy = 0;
%                 agentObject.dailyWeights4MvngAvg_Charty = dailyWeights4MvngAvg_Charty;
                
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
                    agentObject.dayOfPassing = DoB + 36; % average age = 3 years
                elseif agentObject.purposeCategory == "Investor"
                    if randNumber <=.9
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = Platform.risk_mu_fundy + Platform.risk_sigma_fundy * randn;
                        agentObject.proActiveness = Platform.activity_mu_fundy + Platform.activity_sigma_fundy * randn;
                        agentObject.intelligenceGap = Platform.intelligencegap_mu_fundy + Platform.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = Platform.numTermsForeseen_mu_fundy + Platform.numTermsForeseen_sigma_fundy * randn;
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = Platform.risk_mu_charty + Platform.risk_sigma_charty * randn;
                        agentObject.proActiveness = Platform.activity_mu_charty + Platform.activity_sigma_charty * randn(1);
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = Platform.risk_mu_noisy + Platform.risk_sigma_noisy * randn;
                        agentObject.proActiveness = Platform.activity_mu_noisy + Platform.activity_sigma_noisy * randn;
                    end
                    agentObject.liquidity = Platform.rich_mu_liquidity + Platform.rich_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + 48; % average age = 4 years
                elseif agentObject.purposeCategory == "Utilizer"
                    if randNumber <=.9
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = Platform.risk_mu_charty + Platform.risk_sigma_charty * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_charty + Platform.activity_sigma_charty * randn(1);
                    elseif randNumber <=.98
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = Platform.risk_mu_fundy + Platform.risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_fundy + Platform.activity_sigma_fundy * randn(1);
                        agentObject.intelligenceGap = Platform.intelligencegap_mu_fundy + Platform.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = Platform.numTermsForeseen_mu_fundy + Platform.numTermsForeseen_sigma_fundy * randn;
                    else
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = Platform.risk_mu_noisy + Platform.risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_noisy + Platform.activity_sigma_noisy * randn(1);
                    end
                    agentObject.liquidity = Platform.midClass_mu_liquidity + Platform.midClass_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + 24; % average age = 2 years
                else %Speculator
                    if randNumber <=.8
                        agentObject.strategyType = "noisy";
                        agentObject.riskAppetite = Platform.risk_mu_noisy + Platform.risk_sigma_noisy * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_noisy + Platform.activity_sigma_noisy * randn(1);
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                        agentObject.riskAppetite = Platform.risk_mu_charty + Platform.risk_sigma_charty * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_charty + Platform.activity_sigma_charty * randn(1);
                    else
                        agentObject.strategyType = "fundy";
                        agentObject.riskAppetite = Platform.risk_mu_fundy + Platform.risk_sigma_fundy * randn(1);
                        agentObject.proActiveness = Platform.activity_mu_fundy + Platform.activity_sigma_fundy * randn(1);
                        agentObject.intelligenceGap = Platform.intelligencegap_mu_fundy + Platform.intelligencegap_sigma_fundy * randn;
                        agentObject.numTermsForeseen_Fundy = Platform.numTermsForeseen_mu_fundy + Platform.numTermsForeseen_sigma_fundy * randn;
                    end
                    agentObject.liquidity = Platform.poor_mu_liquidity + Platform.poor_sigma_liquidity* randn();
                    agentObject.dayOfPassing = DoB + 12; % average age = 1 year
                    
                end


            end
        end
    end
end
