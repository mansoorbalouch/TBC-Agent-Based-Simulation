import matplotlib.pyplot as plt

# Function to read and parse the file

############ Token-wise analysis ############

def read_token_price_time_series(file_path):
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

def read_token_supply_price(file_path):
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

############## Agent-wise analysis ###########
def read_agent_liquidity(file_path):
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

# Read the data from the file
path = "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/Token-Bonding-Curve-Agent-Based-Simulation/Results/"
file_path = path + 'tbc_sim_linear_500Agents_3Months_transactions_log.txt'
price_time_series_data = read_token_price_time_series(file_path)
supply_price_data = read_token_supply_price(file_path)

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
# # plt.show()


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
plt.show()
