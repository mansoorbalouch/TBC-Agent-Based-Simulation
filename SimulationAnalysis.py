import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

class SimulationAnalysis:

    def __init__(self):

        # Read the data from the file
        path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/"
        transactions_file_path = path + 'Results/tbc_sim_linear_500Agents_40Months_transactions_log.txt'
        agents_file_path = path + 'Results/MyAgents_500.txt'
        save_figures_path_path = path + "Figures/"
        bondingCurveType = "linear"

        agent_liquidity_data = self.plot_agents_distribution(agents_file_path, save_figures_path_path, f"Agents_distribution_by_type")
        # self.plot_agents_distribution(save_figures_path_path, agent_liquidity_data, f"Agents_distribution_by_type")

        agent_liquidity_diff = self.read_agents_liqudity_diff_by_purpose(transactions_file_path, agents_file_path)
        self.plot_agents_liqudity_diff_by_purpose(save_figures_path_path, agent_liquidity_diff, f"Agents_liquidity_difference_by_purpose_{bondingCurveType}")

        agent_liquidity_data = self.read_agent_liquidity(transactions_file_path)
        self.plot_agent_liquidity(save_figures_path_path, agent_liquidity_data, f"Agents_liquidity_{bondingCurveType}")

        price_time_series_data = self.read_token_price_time_series(transactions_file_path)
        self.plot_token_price_time_series(save_figures_path_path, price_time_series_data, f"Tokens_price_time_series_{bondingCurveType}")

        tokens_current_supplies = self.read_tokens_latest_supply(transactions_file_path)
        self.plot_tokens_latest_supply_hist(save_figures_path_path, tokens_current_supplies, f"Tokens_supply_{bondingCurveType}")

        plt.show()

    ############## Agent-wise analysis ###########
    def plot_agents_distribution(self, file_path, save_figures_path, fname):
        # Creating a DataFrame
        df = pd.read_csv(file_path, sep=" ")
        print(df.head)

        grouped_data = df.groupby(['AgentPurposeCategory', 'AgentStrategyType']).size().unstack(fill_value=0)
        # Plotting the stacked bar chart
        plt.figure(figsize=(8,6))
        grouped_data.plot(kind='bar', stacked=True, colormap='viridis', ax=plt.gca())
        plt.title('Agents by Purpose Category and Strategy Type')
        plt.xlabel('Agent Purpose Category')
        plt.ylabel('Number of Agents')
        plt.xticks(rotation=45)
        plt.tight_layout()
        # plt.show()
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
    
        
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

    def plot_agent_liquidity(self, save_figures_path, agent_liquidity_data, fname):

        plt.figure()
        # Plotting price time series
        for agent_id, history in agent_liquidity_data.items():
            if agent_id < 30:
                time, liquidity = zip(*history)
                plt.plot(time, liquidity, label=f'Agent {agent_id}')

        plt.xlabel('Time')
        plt.ylabel('Agent Liquidity')
        plt.title('Agent Liquidity Changes Over Time')
        # plt.legend()
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()
        # plt.show()

    def read_agents_liqudity_diff_by_purpose(self, transactions_file_path, agents_file_path):
        trans_df = pd.read_csv(transactions_file_path, sep=" ")
        agents_df = pd.read_csv(agents_file_path, sep=" ")
        grouped = trans_df.merge(agents_df,  on="AgentID", how="left")
        agents_liq_diff = grouped.loc[:,['AgentID', 'AgentPurposeCategory',"AgentLiquidity_y", "AgentLiquidity_x"]].groupby(['AgentID', 'AgentPurposeCategory']).max("TransactionID")
        agents_liq_diff = agents_liq_diff.reset_index()
        agents_liq_diff["LiquidityDifference"] = agents_liq_diff.loc[:,"AgentLiquidity_y"] -  agents_liq_diff.loc[:,"AgentLiquidity_x"]
        return agents_liq_diff
    
    def plot_agents_liqudity_diff_by_purpose(self, save_figures_path, agents_liq_diff, fname):
        # Plotting the box plots
        plt.figure(figsize=(10, 6))
        sns.boxplot(x='AgentPurposeCategory', y='LiquidityDifference', data=agents_liq_diff)
        plt.title('Box Plot of Liquidity Difference by Agent Purpose Category')
        plt.xlabel('Agent Purpose Category')
        plt.ylabel('Liquidity Difference (Final - Initial)')
        plt.savefig(save_figures_path + fname + ".png")
        plt.close()


    def read_agents_latest_liquidity(self, file_path1, file_path2):
        data = {}
        with open(file_path1, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                agent_id = int(parts[1])
                time = int(parts[0])
                liquidity = float(parts[2]) 

                if agent_id not in data:
                    data[agent_id] = []
                data[agent_id].append((time, liquidity))
                
        latest_supply = {}
        with open(file_path2, 'r') as file:
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

    ############ Token-wise analysis ############

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
    
    def plot_token_price_time_series(self, save_figures_path, price_time_series_data, fname):

        plt.figure()
        # Plotting price time series
        for token_id, history in price_time_series_data.items():
            if token_id < 20:
                time, prices = zip(*history)
                plt.plot(time, prices, label=f'Token {token_id}')

        plt.xlabel('Time')
        plt.ylabel('Token Price')
        plt.title('Token Price Changes Over Time')
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


if __name__ == '__main__':
    simulationAnalysis = SimulationAnalysis()
    print("Plots generated...")