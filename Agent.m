classdef Agent
    properties
        agentID int64;
        purposeCategory string;  %could be either "Creator", "Investor", "Utilizer", or "Speculator"
        strategyType string;
        liquidity double;
        % holdings contain number of tokens held by this agent as key value pair
        tokenHoldingsIDs(1,:) int64;
        tokenHoldingsValues(1,:) double;
        riskAppetite double; % between 0 and 100, used as percentage
        proActiveness double; % between 0 and 100, used as percentage
        intelligenceGap double;
        ownTokenId int64;  % ID of token of this agent, mainly used for agents with purposeCategor = Creator
        dayOfBirth int16;  % Day of joining the platform, both this and dayOfPassing are assumed to be the first of month
        dayOfPassing int16;  % Day of leaving the platform, both this and dayOfBith are assumed to be the first of month
        numTermsForeseen_Fundy int16;  %How many terms (months) ahead an agent with fundamental analysis strategy foresee
        numHindsightTerms_Charty int16;  %How many terms (months) in historical data an agent with Chartist strategy see
        monthlyWeights4MvngAvg_Charty(1,:) double;  %Initial fundy strategy is based the weighted sum of month predicted prices, these are the weights
        monthlyWeights4ExpPrice_Fundy(1,:) double;
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
                agentObject.monthlyWeights4ExpPrice_Fundy = []; % zeros([1,60]);
                agentObject.numHindsightTerms_Charty = 0;
                agentObject.monthlyWeights4MvngAvg_Charty = []; % zeros([1,60]);

                agentObject.tokenHoldingsIDs = [];
                agentObject.tokenHoldingsValues = [];

                randNumber = rand(); %This is a random number for U[0,1] distribution, used for all random parameters setting

                %An investor agent has no riskAppetite, no proActiveness,
                %very likey to have fundamental strategy,
                % The following assume that we have different normal
                % distributions to draw the risk appetite and proActiveness
                % for each type of agents by strategy
                % type agent. The parameters of these normal distributions,
                % risk_mu_charty, risk_mu_charty, poor_mu_liquidity, etc. are plateParams variables

                if agentObject.purposeCategory == "creator"
                    agentObject.strategyType ="none";
                    agentObject.riskAppetite = 0;
                    agentObject.proActiveness = 0;
                    agentObject.liquidity = 0;
                    agentObject.dayOfPassing = DoB + abs(plateParams.creator_mu_DayOfPassing + plateParams.creator_sigma_DayOfPassing * randn); % average age = 3 year
                elseif agentObject.purposeCategory == "Investor"
                    if randNumber <=.9
                        agentObject.strategyType = "fundy";
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                    else
                        agentObject.strategyType = "noisy";
                    end
                    agentObject.liquidity = plateParams.rich_mu_liquidity + plateParams.rich_sigma_liquidity* randn;
                    agentObject.dayOfPassing = abs(DoB + plateParams.rich_mu_DayOfPassing + plateParams.rich_sigma_DayOfPassing* randn); % average age = 4 years

                elseif agentObject.purposeCategory == "Utilizer"
                    if randNumber <=.9
                        agentObject.strategyType = "charty";
                    elseif randNumber <=.98
                        agentObject.strategyType = "fundy";
                    else
                        agentObject.strategyType = "noisy";
                    end
                    agentObject.liquidity = plateParams.midClass_mu_liquidity + plateParams.midClass_sigma_liquidity* randn;
                    agentObject.dayOfPassing = abs(DoB + plateParams.midClass_mu_DayOfPassing + plateParams.midClass_sigma_DayOfPassing* randn); % average age = 2 years
                else %Speculator
                    if randNumber <=.8
                        agentObject.strategyType = "noisy";
                    elseif randNumber <=.98
                        agentObject.strategyType = "charty";
                    else
                        agentObject.strategyType = "fundy";
                    end
                    agentObject.liquidity = plateParams.poor_mu_liquidity + plateParams.poor_sigma_liquidity* randn();
                    agentObject.dayOfPassing = abs(DoB + plateParams.poor_mu_DayOfPassing + plateParams.poor_sigma_DayOfPassing* randn()); % average age = 1 year
                end


                %Now we have set the strategies of each agent category according the
                %distribution.

                %Next we set their other parameters according to their strategies



                if agentObject.strategyType == "fundy"
                    agentObject.riskAppetite = plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn;
                    if agentObject.riskAppetite <=0
                        agentObject.riskAppetite = 0.0001;
                    end
                    if agentObject.riskAppetite >=1
                        agentObject.riskAppetite = 0.9999;
                    end
                    agentObject.proActiveness = plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn;
                    if agentObject.proActiveness <=0
                        agentObject.proActiveness = 0.0001;
                    end
                    if agentObject.proActiveness >=1
                        agentObject.proActiveness = 0.9999;
                    end
                    agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
                    
                    agentObject.numTermsForeseen_Fundy = plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn;
                    if agentObject.numTermsForeseen_Fundy <=0
                        agentObject.numTermsForeseen_Fundy = 1;
                    end
                                       
                    terms = 1:agentObject.numTermsForeseen_Fundy;
                    terms = double(1.0 * terms);
                    agentObject.monthlyWeights4ExpPrice_Fundy = 1./terms;
                    agentObject.monthlyWeights4ExpPrice_Fundy = agentObject.monthlyWeights4ExpPrice_Fundy./sum(agentObject.monthlyWeights4ExpPrice_Fundy);
                    

                    elseif agentObject.strategyType == "charty"
                    agentObject.riskAppetite = plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn;
                    if agentObject.riskAppetite <=0
                        agentObject.riskAppetite = 0.0001;
                    end
                    if agentObject.riskAppetite >=1
                        agentObject.riskAppetite = 0.9999;
                    end
                    agentObject.proActiveness = plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn;
                    if agentObject.proActiveness <=0
                        agentObject.proActiveness = 0.0001;
                    end
                    if agentObject.proActiveness >=1
                        agentObject.proActiveness = 0.9999;
                    end
                    agentObject.numHindsightTerms_Charty = plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn;
                    if agentObject.numHindsightTerms_Charty <=0
                        agentObject.numHindsightTerms_Charty = 1;
                    end
                    terms = 1:agentObject.numHindsightTerms_Charty;
                    terms = double(1.0 * terms);
                    agentObject.monthlyWeights4MvngAvg_Charty = 1./terms;
                    agentObject.monthlyWeights4MvngAvg_Charty = agentObject.monthlyWeights4MvngAvg_Charty./sum(agentObject.monthlyWeights4MvngAvg_Charty);

                elseif agentObject.strategyType == "noisy"
                    agentObject.riskAppetite = plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn;
                    if agentObject.riskAppetite <=0
                        agentObject.riskAppetite = 0.0001;
                    end
                    if agentObject.riskAppetite >=1
                        agentObject.riskAppetite = 0.9999;
                    end
                    agentObject.proActiveness = plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn;

                    if agentObject.proActiveness <=0
                        agentObject.proActiveness = 0.0001;
                    end
                    if agentObject.proActiveness >=1
                        agentObject.proActiveness = 0.9999;
                    end


                end
            end
        end
    end
end


%
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn(1));
%                         agentObject.numHindsightTerms_Charty = abs(plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn);
%                         weights = normalize(rand(1,agentObject.numHindsightTerms_Charty),2);
%                         for term=1:agentObject.numHindsightTerms_Charty
%                             agentObject.monthlyWeights4MvngAvg_Charty(1, term) = weights(1,term);
%                         end
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn(1));
%                         agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
%                         agentObject.numTermsForeseen_Fundy = abs(plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn);
%                         weights = normalize(rand(1,agentObject.numTermsForeseen_Fundy),2); % initialize weights and normalize
%                         for term=1:agentObject.numTermsForeseen_Fundy
%                             agentObject.monthlyWeights4ExpPrice_Fundy(1, term) = weights(1,term);
%                         end
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn(1));
%                     end
%
%
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_noisy + plateParams.risk_sigma_noisy * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_noisy + plateParams.activity_sigma_noisy * randn(1));
%
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_charty + plateParams.risk_sigma_charty * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_charty + plateParams.activity_sigma_charty * randn(1));
%                         agentObject.numHindsightTerms_Charty = abs(plateParams.numHindsightTerms_mu_Charty + plateParams.numHindsightTerms_sigma_Charty * randn);
%                         weights = normalize(rand(1,agentObject.numHindsightTerms_Charty),2);
%                         for term=1:agentObject.numHindsightTerms_Charty
%                             agentObject.monthlyWeights4MvngAvg_Charty(1, term) = weights(1,term);
%                         end
%
%
%                         agentObject.riskAppetite = abs(plateParams.risk_mu_fundy + plateParams.risk_sigma_fundy * randn(1));
%                         agentObject.proActiveness = abs(plateParams.activity_mu_fundy + plateParams.activity_sigma_fundy * randn(1));
%                         agentObject.intelligenceGap = plateParams.intelligencegap_mu_fundy + plateParams.intelligencegap_sigma_fundy * randn;
%                         agentObject.numTermsForeseen_Fundy = abs(plateParams.numTermsForeseen_mu_fundy + plateParams.numTermsForeseen_sigma_fundy * randn);
%                         weights = normalize(rand(1,agentObject.numTermsForeseen_Fundy),2);
%                         for term=1:agentObject.numTermsForeseen_Fundy
%                             agentObject.monthlyWeights4ExpPrice_Fundy(1, term) = weights(1,term);
%                         end
%                     end
%
%
%                 end
%
%
%             end
%         end
%     end
% end