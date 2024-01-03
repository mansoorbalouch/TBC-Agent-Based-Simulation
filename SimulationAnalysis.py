import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import glob
import random

class SimulationAnalysis:

    def __init__(self):

        # Read the data from the file
        path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/"
        
        simulation_dir = "linear_TBC_10000Agents_For_144Terms_2m_5c_1n"
        results_file_paths = glob.glob(f"{path}Results/{simulation_dir}/*")
        agents_wealth_file_path = results_file_paths[0]
        tokens_file_path = results_file_paths[1]
        agents_file_path = results_file_paths[2]
        transactions_file_path = results_file_paths[3]
        bondingCurveType = "Linear"
        # bondingCurveType = "Quadratic"
        
        save_figures_path_path = path + "Figures/"
        
        ################## Agent-wise Analysis ###################
        # agent_liquidity_data = self.plot_agents_distribution(agents_file_path, save_figures_path_path, f"Agents_distribution_by_type_{simulation_dir}")
        # self.plot_agents_distribution(agent_liquidity_data, save_figures_path_path, f"Agents_distribution_by_type_(2m_2c_0n)")

        self.plot_agent_wealth_over_time_by_purpose_category(agents_wealth_file_path, agents_file_path, save_figures_path_path, 
                                                             f"Agent_wealth_over_time_by_purpose_category_{simulation_dir}", f'({bondingCurveType} Bonding Curve)')
        
        self.plot_agent_net_wealth_diff_by_purpose_category(agents_wealth_file_path, agents_file_path, save_figures_path_path, 
                                                             f"Agent_wealth_gained_lost_by_purpose_category_{simulation_dir}", f'({bondingCurveType} Bonding Curve)')
        
        # self.plot_agent_liquidity_time_series_by_purpose_category(transactions_file_path, agents_file_path, save_figures_path_path, 
        #                                                      f"Agent_liquidity_over_time_by_purpose_category_{simulation_dir}", f'({bondingCurveType} Bonding Curve)')

        # agent_liquidity_diff = self.read_agents_liqudity_diff_by_purpose(transactions_file_path, agents_file_path)
        # self.plot_agents_liqudity_diff_by_purpose(save_figures_path_path, agent_liquidity_diff, f"Agents_liquidity_difference_by_purpose_{simulation_dir}", f"({bondingCurveType} Bonding Curve)")

        # # agent_liquidity_data = self.read_agent_liquidity(transactions_file_path)
        # # self.plot_agent_liquidity(save_figures_path_path, agent_liquidity_data, f"Agents_liquidity_{bondingCurveType}", f'({bondingCurveType} Bonding Curve)')

        # ################## Token-wise Analysis ######################
        # self.plot_token_price_time_series_by_life_cycle_type(transactions_file_path, tokens_file_path, save_figures_path_path, 
                                                            #  f"Tokens_price_time_series_by_life_cycle_type_{simulation_dir}", f'({bondingCurveType} Bonding Curve)')

        # # price_time_series_data = self.read_token_price_time_series(transactions_file_path)
        # # self.plot_token_price_time_series(save_figures_path_path, price_time_series_data, f"Tokens_price_time_series_{bondingCurveType}", f'({bondingCurveType} Bonding Curve)')
        
        # token_supply_by_curve_shape_data = self.read_token_supply_by_curve_shape(transactions_file_path, tokens_file_path)
        # self.plot_token_supply_by_curve_shape(save_figures_path_path, token_supply_by_curve_shape_data, f"Token_supply_by_curve_shape_{simulation_dir}", f"({bondingCurveType} Bonding Curve)")

        # tokens_current_supplies = self.read_tokens_latest_supply(transactions_file_path)
        # self.plot_tokens_latest_supply_hist(save_figures_path_path, tokens_current_supplies, f"Tokens_supply_{bondingCurveType}")

        # plt.show()

    ############## Agent-wise analysis ###########
    def plot_agents_distribution(self, file_path, save_figures_path, fname):
        # Creating a DataFrame
        df = pd.read_csv(file_path, sep=" ")

        grouped_data = df.groupby(['AgentPurposeCategory', 'AgentStrategyType']).size().unstack(fill_value=0)
        # Plotting the stacked bar chart
        plt.figure(figsize=(8,6))
        grouped_data.plot(kind='bar', stacked=True, colormap='viridis', ax=plt.gca())
        plt.title('Agents by Purpose Category and Strategy Type', weight='bold')
        plt.xlabel('Agent Purpose Category', fontweight='bold')
        plt.ylabel('Number of Agents', fontweight='bold')
        plt.xticks(rotation=45)
        plt.tight_layout()
        # plt.show()
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()

    
    def plot_agent_wealth_over_time_by_purpose_category(self, agents_wealth_file_path, agents_file_path, save_figures_path, fname, title):
        agents_wealth_df = pd.read_csv(agents_wealth_file_path, sep=" ", header=None).transpose()
        agents_df = pd.read_csv(agents_file_path, sep=" ")
        agents_wealth_df["AgentID"] = agents_wealth_df.iloc[:,0]
        agents_wealth_df = agents_wealth_df.iloc[:,1:]  
        agent_grouped = agents_wealth_df.merge(agents_df,  on="AgentID", how="left")
        # Creating individual plots for each AgentPurposeCategory type
        unique_types = agent_grouped['AgentPurposeCategory'].unique()
        unique_types = ["Investor", "Utilizer", "Speculator"]

        plt.figure(figsize=(10, 6))

        for i, type in enumerate(unique_types):
            type_data = agent_grouped[agent_grouped['AgentPurposeCategory'] == type]
            agend_id = random.choices(type_data["AgentID"].unique())[0]
            sns.lineplot(agents_wealth_df.iloc[int(agend_id), :-1], label=type)

        plt.title(f'Agent Wealth Changes Over Time {title}', weight='bold', fontsize=18)
        plt.xlabel('Time (weeks)', fontweight='bold', fontsize=18)
        plt.ylabel('Net Wealth', fontweight='bold', fontsize=18)
        plt.legend(title='Agent Purpose Category')
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()

    def plot_agent_net_wealth_diff_by_purpose_category(self, agents_wealth_file_path, agents_file_path, save_figures_path, fname, title):
        agents_wealth_df = pd.read_csv(agents_wealth_file_path, sep=" ", header=None).transpose()
        agents_df = pd.read_csv(agents_file_path, sep=" ")

        agents_wealth_df["AgentID"] = agents_wealth_df.iloc[:,0]
        agents_wealth_df = agents_wealth_df.iloc[:,1:]
        agent_grouped = agents_df.merge(agents_wealth_df,  on="AgentID", how="left")
        
        DoB = agent_grouped.loc[:, "DoB"]
        initial_wealth = [None]* len(DoB)
        for i in range(len(DoB)):
            initial_wealth[i] = agent_grouped.iloc[i, 10 + DoB[i]]
        closing_wealth = agent_grouped.iloc[:,-1]
        wealth_diff = closing_wealth - initial_wealth

        agents_wealth_diff_by_purp = pd.DataFrame( {"AgentPurposeCategory": agent_grouped.loc[:,"AgentPurposeCategory"], "WealthDifference": wealth_diff})
        agents_wealth_diff_by_purp = agents_wealth_diff_by_purp.loc[agents_wealth_diff_by_purp["AgentPurposeCategory"] != "Creator"]

        plt.figure(figsize=(10, 6))
        # df.plot(kind='bar', stacked=True, colormap='viridis', ax=plt.gca())
        sns.boxplot(x='AgentPurposeCategory', y='WealthDifference', data = agents_wealth_diff_by_purp)
        plt.title(f'Agents Wealth Gain/Loss {title}', weight='bold', fontsize=18)
        plt.xlabel('Agent Purpose Category', fontweight='bold', fontsize=16)
        plt.ylabel('Wealth Difference (Closing - Initial)', fontweight='bold', fontsize=16)
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()


    def plot_agent_liquidity_time_series_by_purpose_category(self, transactions_file_path, agents_file_path, save_figures_path, fname, title):
        trans_df = pd.read_csv(transactions_file_path, sep=" ")
        agents_df = pd.read_csv(agents_file_path, sep=" ")
        agent_grouped = trans_df.merge(agents_df,  on="AgentID", how="left")
        # Creating individual plots for each AgentPurposeCategory type
        unique_types = agent_grouped['AgentPurposeCategory'].unique()

        plt.figure(figsize=(10, 6))

        for i, type in enumerate(unique_types, 1):
            type_data = agent_grouped[agent_grouped['AgentPurposeCategory'] == type].loc[:,['AgentID', "TransactionID", 'AgentPurposeCategory', "AgentLiquidity_x"]]
            agend_ids = type_data["AgentID"].unique()
            type_data = type_data[type_data["AgentID"] == min(agend_ids)] # random.choices(agend_ids)[0]]
            sns.lineplot(x='TransactionID', y='AgentLiquidity_x', label=type, data=type_data)

        plt.title(f'Agent Liquidity Changes Over Time {title}', weight='bold', fontsize=18)
        plt.xlabel('Time (weeks)', fontweight='bold', fontsize=18)
        plt.ylabel('Agent Liquidity', fontweight='bold', fontsize=18)
        plt.legend(title='Agent Purpose Category')
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
    
     
    def read_agents_liqudity_diff_by_purpose(self, transactions_file_path, agents_file_path):
        trans_df = pd.read_csv(transactions_file_path, sep=" ")
        agents_df = pd.read_csv(agents_file_path, sep=" ")
        grouped = trans_df.merge(agents_df,  on="AgentID", how="left")
        agents_liq_diff = grouped.loc[:,['AgentID', 'AgentPurposeCategory',"AgentLiquidity_y", "AgentLiquidity_x"]].groupby(['AgentID', 'AgentPurposeCategory']).max("TransactionID")
        agents_liq_diff = agents_liq_diff.reset_index()
        agents_liq_diff["LiquidityDifference"] = agents_liq_diff.loc[:,"AgentLiquidity_y"] -  agents_liq_diff.loc[:,"AgentLiquidity_x"]
        return agents_liq_diff
    
    def plot_agents_liqudity_diff_by_purpose(self, save_figures_path, agents_liq_diff, fname, title):
        # Plotting the box plots
        plt.figure(figsize=(10, 6))
        sns.boxplot(x='AgentPurposeCategory', y='LiquidityDifference', data=agents_liq_diff)
        plt.title(f'Liquidity Gained/Lost by Agents {title}', weight='bold', fontsize=18)
        plt.xlabel('Agent Purpose Category', fontweight='bold', fontsize=16)
        plt.ylabel('Liquidity Difference (Final - Initial)', fontweight='bold', fontsize=16)
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()


    ############ Token-wise analysis ############
        
    def plot_token_price_time_series_by_life_cycle_type(self, transactions_file_path, tokens_file_path, save_figures_path, fname, title):
        trans_df = pd.read_csv(transactions_file_path, sep=" ")
        tokens_df = pd.read_csv(tokens_file_path, sep=" ")
        grouped = trans_df.merge(tokens_df,  on="TokenID", how="left")
        token_price_time_series = grouped.loc[:,['TokenID', 'TransactionID',"LifeCycleCurveShape", 'TokenCurrentBuyPrice']].groupby(["TokenID", "TransactionID","LifeCycleCurveShape"]).head()
        token_price_time_series['LifeCycleCurveShape'] = token_price_time_series['LifeCycleCurveShape'].str.replace('_\d+x', '', regex=True)
        token_price_time_series = token_price_time_series.sort_values("TokenID")

        # Creating individual plots for each LifeCycleCurveShape type
        unique_types = token_price_time_series['LifeCycleCurveShape'].unique()

        plt.figure(figsize=(12, 8))

        for i, type in enumerate(unique_types, 1):
            # plt.subplot(4, 2, i)
            type_data = token_price_time_series[token_price_time_series['LifeCycleCurveShape'] == type]
            token_ids = type_data["TokenID"].unique()
            type_data = type_data[type_data["TokenID"] == random.choices(token_ids)[0]]
            sns.lineplot(x='TransactionID', y='TokenCurrentBuyPrice', label=type, data=type_data)

        plt.title(f'Token Price Time Series {title}', weight='bold', fontsize=22)
        plt.xlabel('Time (weeks)', fontweight='bold', fontsize=18)
        plt.ylabel('Token Current Price', fontweight='bold', fontsize=18)
        plt.legend(title='Life Cycle Curve Shape')
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
        
    def read_token_supply_by_curve_shape(self, transactions_file_path, tokens_file_path):
        trans_df = pd.read_csv(transactions_file_path, sep=" ")
        tokens_df = pd.read_csv(tokens_file_path, sep=" ")
        grouped = trans_df.merge(tokens_df,  on="TokenID", how="left")
        token_supply_diff = grouped.loc[:,['TokenID', 'TransactionID',"LifeCycleCurveShape", 'TokenCurrentSupply']].groupby(['TokenID', 'LifeCycleCurveShape']).max("TransactionID").reset_index()
        token_supply_diff['LifeCycleCurveShape_Grouped'] = token_supply_diff['LifeCycleCurveShape'].str.replace('_\d+x', '', regex=True)
        return token_supply_diff
    
    def plot_token_supply_by_curve_shape(self, save_figures_path, token_supply_diff, fname, title):
        # Plotting the box plots
        plt.figure(figsize=(10, 6))
        sns.boxplot(x='LifeCycleCurveShape_Grouped', y='TokenCurrentSupply', data=token_supply_diff)
        plt.title(f'Supply Collected by Tokens {title}', weight='bold', fontsize=18)
        plt.xlabel('Life Cycle Shape', fontweight='bold', fontsize=16)
        plt.ylabel('Token Supply', fontweight='bold', fontsize=16)
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()

# ------------------------------------------------------------------------------------------------- #

    def read_token_price_time_series(self, file_path):
        data = {}
        with open(file_path, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                token_id = int(parts[5])
                time = int(parts[0])
                price = float(parts[7])  # Use either TokenCurrentBuyPrice or TokenCurrentSellPrice

                if token_id not in data:
                    data[token_id] = []
                data[token_id].append((time, price))
        return data
    
    def plot_token_price_time_series(self, save_figures_path, price_time_series_data, fname,title):

        plt.figure()
        # Plotting price time series
        for token_id, history in price_time_series_data.items():
            if token_id < 20:
                time, prices = zip(*history)
                plt.plot(time, prices, label=f'Token {token_id}')

        plt.xlabel('Time (weeks)')
        plt.ylabel('Token Price')
        plt.title(f'Token Price Changes Over Time {title}', weight='bold', fontsize=18)
        # plt.legend()
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
        # # plt.show()

    
    def read_tokens_latest_supply(self, file_path):
        latest_supply = {}
        with open(file_path, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                transaction_id = int(parts[0])
                token_id = int(parts[5])
                current_supply = float(parts[8])  # The current supply of the token

                # Update the supply for the highest transaction ID of each token
                if token_id not in latest_supply or transaction_id > latest_supply[token_id][0]:
                    latest_supply[token_id] = (transaction_id, current_supply)

        # Return only the supply values
        return [supply for _, supply in latest_supply.values()]
    
    def plot_tokens_latest_supply_hist(self, save_figures_path, tokens_current_supplies, fname):
        # Plotting the histogram
        plt.figure()
        plt.hist(tokens_current_supplies, bins=20, color='blue', alpha=0.7)
        plt.xlabel('Current Supply')
        plt.ylabel('Number of Tokens')
        plt.title('Current Supply of All Tokens')
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
        # plt.show()

    def read_token_supply_price(self, file_path):
        data = {}
        with open(file_path, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                token_id = int(parts[5])
                supply = float(parts[8])
                price = float(parts[7])  # Use either TokenCurrentBuyPrice or TokenCurrentSellPrice

                if token_id not in data:
                    data[token_id] = []
                data[token_id].append((supply, price))
        return data

    
    def plot_token_supply_price(self, supply_price_data):

        plt.figure()
        # Plotting price time series
        for token_id, history in supply_price_data.items():
            if token_id < 10:
                supply, prices = zip(*history)
                plt.plot(supply, prices, label=f'Token {token_id}')

        plt.xlabel('Token Supply')
        plt.ylabel('Token Price')
        plt.title('Token Price Changes Over Supply')
        plt.legend()
       
    def read_agent_liquidity(self, file_path):
        data = {}
        with open(file_path, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                agent_id = int(parts[1])
                time = int(parts[0])
                liquidity = float(parts[2]) 

                if agent_id not in data:
                    data[agent_id] = []
                data[agent_id].append((time, liquidity))
        return data

    def plot_agent_liquidity(self, save_figures_path, agent_liquidity_data, fname, title):

        plt.figure()
        # Plotting price time series
        for agent_id, history in agent_liquidity_data.items():
            if agent_id < 30:
                time, liquidity = zip(*history)
                plt.plot(time, liquidity, label=f'Agent {agent_id}')

        plt.xlabel('Time')
        plt.ylabel('Agent Liquidity')
        plt.title(f'Agent Liquidity Changes Over Time {title}', weight='bold', fontsize=18)
        # plt.legend()
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
        # plt.show()


if __name__ == '__main__':
    simulationAnalysis = SimulationAnalysis()
    print("Plots generated...")