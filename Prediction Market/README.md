This repo represents the first steps (contracts files only) of a prediction market dApp. For now, a trusted solver (chosen by the owner) can answer any question. Plus, the reward of a gambler is based on what people have bet on the corresponding question. Anyone can bet as long as the trusted solver hasn't decided the outcome.

The Owned.sol file contains the definition of the contract owner, the change owner, add solver, remove solver abilities.

The PredictionHub.sol file contains question creation/deletion functions.

TheTrustedSolver.sol file contains the solver outcomes implementation.

The Bets.sol file contains the bet function and the withdraw reward function.




