import matplotlib.pyplot as plt

class SimulationAnalysis:

    def __init__(self):

        # Read the data from the file
        path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/"
        file_path = path + 'Results/tbc_sim_linear_500Agents_40Months_transactions_log.txt'
        save_figures = path + "Figures/"

        price_time_series_data = self.read_token_price_time_series(file_path)
        tokens_current_supplies = self.read_tokens_latest_supply(file_path)
        # supply_price_data = self.read_token_supply_price(file_path)
        agent_liquidity_data = self.read_agent_liquidity(file_path)

        self.plot_token_price_time_series(save_figures, price_time_series_data)
        self.plot_tokens_latest_supply_hist(save_figures, tokens_current_supplies)
        self.plot_agent_liquidity(save_figures, agent_liquidity_data)
        plt.show()


    ############## Agent-wise analysis ###########
    def read_agent_liquidity(self, file_path):
        data = {}
        with open(file_path, 'r') as file:
            next(file)  # Skip the header line
            for line in file:
                parts = line.split()
                agent_id = int(parts[1])
                time = int(parts[0])
                liquidity = float(parts[2])  # Use either TokenCurrentBuyPrice or TokenCurrentSellPrice

                if agent_id not in data:
                    data[agent_id] = []
                data[agent_id].append((time, liquidity))
        return data

    def plot_agent_liquidity(self, save_figures, agent_liquidity_data):

        plt.figure()
        # Plotting price time series
        for agent_id, history in agent_liquidity_data.items():
            if agent_id < 10:
                time, liquidity = zip(*history)
                plt.plot(time, liquidity, label=f'Agent {agent_id}')

        plt.xlabel('Time')
        plt.ylabel('Agent Liquidity')
        plt.title('Agent Liquidity Changes Over Time')
        plt.legend()
        plt.savefig(save_figures + "agent_liquidity_over_time.png")
        plt.close()
        # plt.show()


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
    
    def plot_token_price_time_series(self, save_figures, price_time_series_data):

        plt.figure()
        # Plotting price time series
        for token_id, history in price_time_series_data.items():
            if token_id < 10:
                time, prices = zip(*history)
                plt.plot(time, prices, label=f'Token {token_id}')

        plt.xlabel('Time')
        plt.ylabel('Token Price')
        plt.title('Token Price Changes Over Time')
        plt.legend()
        plt.savefig(save_figures + "token_price_time_series.png")
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
    
    def plot_tokens_latest_supply_hist(self, save_figures, tokens_current_supplies):
        # Plotting the histogram
        plt.figure()
        plt.hist(tokens_current_supplies, bins=20, color='blue', alpha=0.7)
        plt.xlabel('Current Supply')
        plt.ylabel('Number of Tokens')
        plt.title('Current Supply of All Tokens')
        plt.savefig(save_figures + "tokens_latest_supply_hist.png")
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


simulationAnalysis = SimulationAnalysis()
print("Plots generated...")