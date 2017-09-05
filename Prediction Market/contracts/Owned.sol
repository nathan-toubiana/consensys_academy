pragma solidity ^0.4.6;

contract Owned {
    
    address public owner;
    
    event LogNewOwner(address sender, address oldOwner, address newOwner);
    event addedSolver(address solver,uint blockNumber);
    event removedSolver(address solver,uint blockNumber);
    
    mapping (address => bool) public trustedSolvers;
    
    modifier onlyOwner { 
        if(msg.sender != owner) throw;
        _; 
    }
    
    function Owned() {
        owner = msg.sender;
    }
    
    function changeOwner(address newOwner)
        onlyOwner
        returns(bool success)
    {
        if(newOwner == 0) throw;
        LogNewOwner(msg.sender, owner, newOwner);
        owner = newOwner;
        return true;
    }
    
    function addSolver(address solver)
        onlyOwner
        returns(bool success)
        
        {
            
        trustedSolvers[solver]=true;
       addedSolver(solver,block.number);
       return true;
       
   }
   
   function removeSolver(address solver)
        onlyOwner
        returns(bool success)
        
        {
        if(trustedSolvers[solver]==false) throw;
        trustedSolvers[solver]=false;
       removedSolver(solver,block.number);
       return true;
       
   }