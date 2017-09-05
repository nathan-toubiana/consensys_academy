pragma solidity ^0.4.6;

import "./TrustedSolver.sol";

contract Bets is TrustedSolver {
    
    event LogNewBet(address gambler, string question, uint amount, bool predicted_outcome);
    event LogWithdrawal(address gambler, uint amount);

    mapping (address =>  mapping(string => uint)) gamblersFundsMapping;
    mapping (address =>  mapping(string => bool)) gamblersPredictionsMapping;
    
    mapping(string => uint) yesFunds;
    mapping(string => uint) noFunds;
    
    
    
   
    
    modifier onlyIfStillUndecided(string question) { 
        if(questionOutcomes[question].blockNumber!=0) throw;
        _; 
    }
    
    function betOnQuestion(string question, bool predicted_outcome) 
        public
        payable
        onlyIfQuestion(question)
        onlyIfStillUndecided(question)
        returns(bool success)
    {
        if(msg.value==0) throw;
        uint amount=msg.value;
        gamblersFundsMapping[msg.sender][question]+= amount;
        
        if(predicted_outcome==true) yesFunds[question]+=amount;
         if(predicted_outcome==false) noFunds[question]+=amount;
        
        gamblersPredictionsMapping[msg.sender][question]= predicted_outcome;
        
        LogNewBet(msg.sender, question,  amount,  predicted_outcome);
        
        return true;
    }
    
    function requestWithdrawal(string question) 
        public
        returns(bool success) 
    {
        if(questionOutcomes[question].blockNumber==0) throw;
        if(gamblersFundsMapping[msg.sender][question]==0) throw;
        
        uint amount = gamblersFundsMapping[msg.sender][question];
        gamblersFundsMapping[msg.sender][question]=0;
        
        bool observed_outcome=questionOutcomes[question].observed_outcome;
        
        bool predicted_outcome=gamblersPredictionsMapping[msg.sender][question];
        
        if(predicted_outcome!=observed_outcome) throw;
        
        uint yes_amount=yesFunds[question];
        uint no_amount=noFunds[question];
        
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
    