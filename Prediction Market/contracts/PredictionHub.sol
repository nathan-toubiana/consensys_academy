pragma solidity ^0.4.6;

import "./Owned.sol";

contract predictionHub is Owned {
    
    string[] public questions;
    mapping(string => bool) questionExists;
    
    modifier onlyIfQuestion(string question) {
        if(questionExists[question] != true) throw;
        _;
    }
    
    event LogNewQuestion(address sender,string question);
    event LogQuestionDeleted(address sender, string question);
    
    function getQuestionCount()
        public
        constant
        returns(uint questionCount)
    {
        return questions.length;
    }
    
    function createQuestion(string question)
        onlyOwner
        returns(bool success)
    {
        
        questions.push(question);
        if (questionExists[question] == true) throw;
        questionExists[question] = true;
        LogNewQuestion(msg.sender,question);
        return true;
    }
    
    // Pass-through Admin Controls
    
    function deleteQuestion(string question) 
        onlyOwner
        onlyIfQuestion(question)
        returns(bool success)
    {
        questionExists[question] = false;

        LogQuestionDeleted(msg.sender,question);
        return true;
    }
    
    
    