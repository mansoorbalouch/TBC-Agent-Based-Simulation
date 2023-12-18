# TBC-Agent-Based-Simulation

## Overview
This repository contains an agent-based simulation of a multi-token economy system. The simulation models the behavior of various platform participants, such as creators, buyers, investors, and speculators. It captures the heterogeneity, bounded rationality, learning, adaptation, and network effects of these agents.

## Project Structure
### Classes

- [Agent.m:] Defines the characteristics, behaviors, and goals of platform participants (agents).
- [Token.m:] Represents tokens used within the platform, defining their attributes and interactions.
- [Platform.m:] Defines the structure and mechanisms of the platform, creates agents with specific attributes and behaviors, and executes the simulation for a specified number of time steps, capturing agent interactions, decision-making processes, and platform dynamics.


### Simulation Objectives
The simulation aims to:

- Model realistic agent behaviors and decision-making processes within a multi-token economy.
- Analyze the properties of the platform, including price discovery, supply and demand trends, volatility, and arbitrage opportunities resulting from agent interactions.
- Investigate the impact of various bonding curve shapes, parameters, and agent behaviors on platform dynamics.


### Results and Analysis
The simulation outputs data capturing the interactions and behaviors of agents, platform dynamics, and emergent properties. These outputs can be used for:

- Explanatory analysis to understand the observed behaviors and trends.
- Exploratory analysis to uncover insights into platform dynamics.
- Predictive tasks to forecast how changes in bonding curve parameters or agent behaviors affect the platform.
