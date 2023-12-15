% this class defines the token parameters

classdef PlformParams
    properties
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
        numHindsightTerms_mu_Charty int16;
        numHindsightTerms_sigma_Charty int16;

        creator_mu_DayOfPassing int16;
        creator_sigma_DayOfPassing int16;
        rich_mu_DayOfPassing int16;
        rich_sigma_DayOfPassing int16;
        midClass_mu_DayOfPassing int16;
        midClass_sigma_DayOfPassing int16;
        poor_mu_DayOfPassing int16;
        poor_sigma_DayOfPassing int16;

    end

    methods
        function PlfromParams = PlformParams(risk_mu_fundy,risk_sigma_fundy,risk_mu_charty,risk_sigma_charty,risk_mu_noisy,risk_sigma_noisy,activity_mu_fundy,activity_sigma_fundy,activity_mu_charty,activity_sigma_charty,activity_mu_noisy,activity_sigma_noisy,midClass_mu_liquidity,midClass_sigma_liquidity ,rich_mu_liquidity ,rich_sigma_liquidity ,poor_mu_liquidity ,poor_sigma_liquidity ,intelligencegap_mu_fundy ,intelligencegap_sigma_fundy ,numTermsForeseen_mu_fundy ,numTermsForeseen_sigma_fundy, numHindsightTerms_mu_Charty, numHindsightTerms_sigma_Charty, creator_mu_DayOfPassing ,creator_sigma_DayOfPassing ,rich_mu_DayOfPassing ,rich_sigma_DayOfPassing ,midClass_mu_DayOfPassing ,midClass_sigma_DayOfPassing ,poor_mu_DayOfPassing ,poor_sigma_DayOfPassing)

            PlfromParams.risk_mu_fundy=risk_mu_fundy;
            PlfromParams.risk_sigma_fundy=risk_sigma_fundy;
            PlfromParams.risk_mu_charty=risk_mu_charty;
            PlfromParams.risk_sigma_charty=risk_sigma_charty;
            PlfromParams.risk_mu_noisy=risk_mu_noisy;
            PlfromParams.risk_sigma_noisy=risk_sigma_noisy;
            PlfromParams.activity_mu_fundy=activity_mu_fundy;
            PlfromParams.activity_sigma_fundy=activity_sigma_fundy;
            PlfromParams.activity_mu_charty=activity_mu_charty;
            PlfromParams.activity_sigma_charty=activity_sigma_charty;
            PlfromParams.activity_mu_noisy=activity_mu_noisy;
            PlfromParams.activity_sigma_noisy=activity_sigma_noisy;
            PlfromParams.midClass_mu_liquidity=midClass_mu_liquidity;
            PlfromParams.midClass_sigma_liquidity =midClass_sigma_liquidity ;
            PlfromParams.rich_mu_liquidity =rich_mu_liquidity ;
            PlfromParams.rich_sigma_liquidity =rich_sigma_liquidity ;
            PlfromParams.poor_mu_liquidity =poor_mu_liquidity ;
            PlfromParams.poor_sigma_liquidity =poor_sigma_liquidity ;
            PlfromParams.intelligencegap_mu_fundy =intelligencegap_mu_fundy ;
            PlfromParams.intelligencegap_sigma_fundy =intelligencegap_sigma_fundy ;
            PlfromParams.numTermsForeseen_mu_fundy =numTermsForeseen_mu_fundy ;
            PlfromParams.numTermsForeseen_sigma_fundy =numTermsForeseen_sigma_fundy ;
            PlfromParams.numHindsightTerms_mu_Charty =numHindsightTerms_mu_Charty ;
            PlfromParams.numHindsightTerms_sigma_Charty =numHindsightTerms_sigma_Charty ;
            PlfromParams.creator_mu_DayOfPassing =creator_mu_DayOfPassing ;
            PlfromParams.creator_sigma_DayOfPassing =creator_sigma_DayOfPassing ;
            PlfromParams.rich_mu_DayOfPassing =rich_mu_DayOfPassing ;
            PlfromParams.rich_sigma_DayOfPassing =rich_sigma_DayOfPassing ;
            PlfromParams.midClass_mu_DayOfPassing =midClass_mu_DayOfPassing ;
            PlfromParams.midClass_sigma_DayOfPassing =midClass_sigma_DayOfPassing ;
            PlfromParams.poor_mu_DayOfPassing =poor_mu_DayOfPassing ;
            PlfromParams.poor_sigma_DayOfPassing=poor_sigma_DayOfPassing;
        end
    end
end
