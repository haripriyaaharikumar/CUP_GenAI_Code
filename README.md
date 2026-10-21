# Code forked from CUP: Conversation Uncertainty-Aware Planning
Paper : https://arxiv.org/pdf/2604.03924

CUP is a framework for goal-oriented conversational systems that uses uncertainty as a planning signal for multi-turn decision making. It integrates language models with Monte Carlo Tree Search to balance information acquisition and target commitment.


**Workflow**:

1. **Belief & Uncertainty Modeling** — Maintains a probability distribution over candidates using SBERT similarity, quantifies uncertainty via entropy, and computes Expected Information Gain for candidate actions (`belief.py`, `similarity.py`)

2. **Uncertainty-Guided Planning** — An LLM proposes feasible actions grounded against candidates distributions, then MCTS with EIG-based priors evaluates their long-term impact over simulated trajectories (`action_proposer.py`, `mcts.py`)

3. **Language-Grounded Action Execution** — The selected action is verbalized by the LLM, presented to the user simulator, and the belief state is updated via Bayesian multiplicative updates (`environment.py`, `simulator.py`)



## Requirements

Python 3.10+, PyTorch, Transformers, sentence-transformers, tqdm, numpy.
