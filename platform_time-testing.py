from Platform import Platform
import timeit
import matplotlib.pyplot as plt
import itertools
import subprocess
from multiprocessing import Pool

def run_script(args):
    num_agents, bondingCurve, param1, param2, param3 = args
    numMonths = 144  # This seems to be a constant in your case

    # Assuming your_script.py accepts command-line arguments
    # Adjust as per your script's requirements
    subprocess.run(["python3", "/media/dataanalyticlab/Drive2/MANSOOR/DeFI-Agent/Code/Bonding-Curves/TBC-Agent-Based-Simulation/Platform.py",
                     str(num_agents), str(numMonths), bondingCurve, str(param1), str(param2), str(param3)])

if __name__ == "__main__":
    num_agents_list = [1000, 5000, 10000]
    bondingCurves = ["linear", "polynomial"]
    params1 = [2, 10]
    params2 = [5, 20]
    params3 = [1, 2]

    # Generate all combinations of parameters
    # all_combinations = list(itertools.product(num_agents_list, bondingCurves, params1, params2, params3))
    all_combinations = [(num_agents_list[0], bondingCurves[0], params1[0], params2[0], params3[0]),
                    (num_agents_list[0], bondingCurves[1], params1[0], params2[0], params3[1]),
                    (num_agents_list[1], bondingCurves[0], params1[0], params2[0], params3[0]),
                    (num_agents_list[1], bondingCurves[1], params1[0], params2[0], params3[1]),
                    (num_agents_list[2], bondingCurves[0], params1[0], params2[0], params3[0]),
                    (num_agents_list[2], bondingCurves[1], params1[0], params2[0], params3[1])]

    # Use a multiprocessing Pool to run the script in parallel for each combination
    with Pool() as pool:
        pool.map(run_script, all_combinations)


# # Store the results
# time_results = []

# for numAgents in num_agents_list:
#     times_for_this_numAgents = []
#     for bondingCurve in bondingCurves:
#         for param in range(len(params1)):
#             param1 = params1[param]
#             param2 = params2[param]
#             # param3 = params3[param]
#             if bondingCurve == "linear":
#                 param3 = 1
#             else:
#                 param3 = 2
#             start = timeit.default_timer()
#             platform = Platform(numAgents, numMonths, bondingCurve, param1=param1, param2=param2, param3=param3)
#             stop = timeit.default_timer()
#             time_elapsed = stop - start
#             times_for_this_numAgents.append(time_elapsed)
#             print(f"{bondingCurve} bonding curve simulation completed for {numAgents} agents with parameters (m={param1}, c = {param2}, n={param3})")

#         time_results.append(times_for_this_numAgents)




# # Plotting the results
# for i, numAgents in enumerate(num_agents_list):
#     plt.plot(months_list, time_results[i], label=f'{numAgents} Agents')

# plt.xlabel('Months')
# plt.ylabel('Time Elapsed (seconds)')
# plt.title('Simulation Time vs Months for Varying Number of Agents')
# plt.legend()
# plt.show()
