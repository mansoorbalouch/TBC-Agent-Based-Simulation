from Platform import Platform
import timeit
import matplotlib.pyplot as plt

months_list = [2, 4, 6, 8, 10]
num_agents_list = [500 * i for i in range(1, len(months_list) + 1)]

# Store the results
time_results = []

for numAgents in num_agents_list:
    p = Platform(numAgents, "linear", 5, 0)
    times_for_this_numAgents = []
    for months in months_list:
        start = timeit.default_timer()
        p.run_simulation(months)
        stop = timeit.default_timer()
        time_elapsed = stop - start
        times_for_this_numAgents.append(time_elapsed)
    time_results.append(times_for_this_numAgents)

# Plotting the results
for i, numAgents in enumerate(num_agents_list):
    plt.plot(months_list, time_results[i], label=f'{numAgents} Agents')

plt.xlabel('Months')
plt.ylabel('Time Elapsed (seconds)')
plt.title('Simulation Time vs Months for Varying Number of Agents')
plt.legend()
plt.show()