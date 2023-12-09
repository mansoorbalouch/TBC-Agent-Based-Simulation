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

   end

   methods
        function platFormObject = Platform(buyFunc, sellFunc, transFee, discountRate)
            if nargin > 0
                platFormObject.buyFunc = buyFunc;
                platFormObject.sellFunc = sellFunc;
                platFormObject.transactionFee = transFee;
                platFormObject.discountRate = discountRate;
            end
        end

        
   end
end