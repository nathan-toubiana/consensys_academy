pragma solidity ^0.4.6;

import "./PredictionHub.sol";

contract TrustedSolver is predictionHub {
   
   struct questionOutcomesStruct {
    uint blockNumber;
    bool observed_outcome;
}
    mapping (bytes32 => questionOutcomesStruct) questionOutcomes;
    
    event LogNewDecision(address solver, bytes32 question,  bool decided_outcome);
   
   
    modifier onlySolver() { 
        if(trustedSolvers[msg.sender]==false) throw;
        _; 
    }
    
    
     function solveQuestion(bytes32 question,bool decided_outcome)
        onlySolver
        onlyIfQuestion(question)
        returns(bool success)
    {
        questionOutcomes[question].blockNumber=block.number;
        questionOutcomes[question].observed_outcome=decided_outcome;
        LogNewDecision(msg.sender, question,  decided_outcome);
        return true;
        
    }
   
    
}