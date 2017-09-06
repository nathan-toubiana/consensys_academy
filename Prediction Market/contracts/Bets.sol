pragma solidity ^0.4.6;

import "./TrustedSolver.sol";

contract Bets is TrustedSolver {
    
    event LogNewBet(address gambler, bytes32 question, uint amount, bool predicted_outcome);
    event LogWithdrawal(address gambler, uint amount);

    struct GamblerStruct {
        mapping(bytes32 => uint) fund;
        mapping(bytes32 => bool) prediction;
                        }

    mapping (address =>  GamblerStruct) gamblersStructs;
    
    struct FundStruct {
        uint yesFunds;
        uint noFunds;
                        }
    mapping(bytes32 =>FundStruct) fundStructs;
    
   
    
    modifier onlyIfStillUndecided(bytes32 question) { 
        if(questionOutcomes[question].blockNumber!=0) throw;
        _; 
    }
    
    function betOnQuestion(bytes32 question, bool predicted_outcome) 
        public
        payable
        onlyIfQuestion(question)
        onlyIfStillUndecided(question)
        returns(bool success)
    {
        if(msg.value==0) throw;
        uint amount=msg.value;

        gamblersStructs[msg.sender].fund[question]+= amount;
        
        if(predicted_outcome==true) yesFunds[question]+=amount;
         if(predicted_outcome==false) noFunds[question]+=amount;
        
        gamblersStructs[msg.sender].prediction[question]=predicted_outcome;
        
        LogNewBet(msg.sender, question,  amount,  predicted_outcome);
        
        return true;
    }
    
    function requestWithdrawal(bytes32 question) 
        public
        returns(bool success) 
    {
        if(questionOutcomes[question].blockNumber==0) throw;
        if(gamblersStructs[msg.sender].fund[question]==0) throw;
        
        uint amount = gamblersStructs[msg.sender].fund[question];
        gamblersStructs[msg.sender].fund[question]=0;
        
        bool observed_outcome=questionOutcomes[question].observed_outcome;
        
        bool predicted_outcome=gamblersStructs[msg.sender].prediction[question];
        
        if(predicted_outcome!=observed_outcome) throw;
        
        uint yes_amount=fundStructs[question].yesFunds;
        uint no_amount=fundStructs[question].noFunds;
        
        if(predicted_outcome==true){
            
        uint winIfYes=amount*((yes_amount+no_amount)/(yes_amount));
         if(!msg.sender.send(winIfYes)) throw;
          LogWithdrawal(msg.sender, winIfYes);
            
            
        }
        
        if(predicted_outcome==false){
            
        uint winIfNo=amount*((yes_amount+no_amount)/(no_amount));
        if(!msg.sender.send(winIfNo)) throw;
        LogWithdrawal(msg.sender, winIfNo);
            
            
        }
    
        

        return true;
    }
    