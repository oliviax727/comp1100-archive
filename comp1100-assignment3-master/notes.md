Reason why algorithim is bad is because it assumes opponent is greedy.

Better to also make the generateTree produce a HTree. This will reduce complexity as GTrees are massive spacewise.

Assume that it is unusual for two nodes to have the same heuristic yet one be the designated (and better) route from ABP.

The heuristic tree after initial gamestates is symmetric, assuming a simple heuristic of counting scores.


It is assumed simpleH acts similar to heuristic in edge cases. The correct implementation of heuristic for standard boards implies so for all functions it calls.

To Do:
- Code Cleanup
- Unit Tests
- Technical Report