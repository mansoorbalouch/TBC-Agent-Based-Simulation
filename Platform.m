% this class defines the system parameters

classdef Platform
    properties
        buyFunc function_handle;
        sellFunc function_handle;
        transactionFee double;
        discountRate double;


        % The following assume that we have different normal
        % distributions to draw the risk appetite and proActiveness
        % for each type of agents by strategy
        % type agent. The parameters of these normal distributions,
        % risk_mu_charty, risk_mu_charty, etc. are Platform variables

        risk_mu_fundy double;
        risk_sigma_fundy double;
        risk_mu_charty double;
        risk_sigma_charty double;
        risk_mu_noisy double;
        risk_sigma_noisy double;

        activity_mu_fundy double;
        activity_sigma_fundy double;
        activity_mu_charty double;
        activity_sigma_charty double;
        activity_mu_noisy double;
        activity_sigma_noisy double;

        midClass_mu_liquidity double;
        midClass_sigma_liquidity double;
        rich_mu_liquidity double;
        rich_sigma_liquidity double;
        poor_mu_liquidity double;
        poor_sigma_liquidity double;

        intelligencegap_mu_fundy double;
        intelligencegap_sigma_fundy double;

        numTermsForeseen_mu_fundy int16;
        numTermsForeseen_sigma_fundy int16;

    end

    methods
        function platFormObject = Platform()
%             if nargin > 0
                platFormObject.buyFunc = @(s) 2*s;
                platFormObject.sellFunc = @(s) 1.5*s;

                platFormObject.risk_mu_fundy = 20;
                platFormObject.risk_sigma_fundy = 3;
                platFormObject.risk_mu_charty = 40;
                platFormObject.risk_sigma_charty = 5;
                platFormObject.risk_mu_noisy = 60;
                platFormObject.risk_sigma_noisy = 10;

                platFormObject.activity_mu_fundy = 15;
                platFormObject.activity_sigma_fundy = 4;
                platFormObject.activity_mu_charty = 35;
                platFormObject.activity_sigma_charty = 9;
                platFormObject.activity_mu_noisy = 50;
                platFormObject.activity_sigma_noisy =  7;

                platFormObject.midClass_mu_liquidity =  5000;
                platFormObject.midClass_sigma_liquidity =  500;
                platFormObject.rich_mu_liquidity = 10000;
                platFormObject.rich_sigma_liquidity = 1000;
                platFormObject.poor_mu_liquidity = 2000;
                platFormObject.poor_sigma_liquidity = 300;

                platFormObject.intelligencegap_mu_fundy = 20;
                platFormObject.intelligencegap_sigma_fundy = 5;
                
                platFormObject.numTermsForeseen_mu_fundy = 18;
                platFormObject.numTermsForeseen_sigma_fundy = 3;


%             end
        end


    end
end