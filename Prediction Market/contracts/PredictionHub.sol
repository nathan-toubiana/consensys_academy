pragma solidity ^0.4.6;

import "./Owned.sol";

contract predictionHub is Owned {
    
    bytes32[] public questions;
    mapping(bytes32 => bool) questionExists;
    
    modifier onlyIfQuestion(bytes32 question) {
        if(questionExists[question] != true) throw;
        _;
    }
    
    event LogNewQuestion(address sender,bytes32 question);
    event LogQuestionDeleted(address sender, bytes32 question);
    
    function getQuestionCount()
        public
        constant
        returns(uint questionCount)
    {
        return questions.length;
    }
    
    function createQuestion(bytes32 question)
        onlyOwner
        returns(bool success)
    {
        if (questionExists[question] == true) throw;
        questions.push(question);
        questionExists[question] = true;
        LogNewQuestion(msg.sender,question);
        return true;
    }
    
    // Pass-through Admin Controls
    
    function deleteQuestion(bytes32 question) 
        onlyOwner
        onlyIfQuestion(question)
        returns(bool success)
    {
        questionExists[question] = false;

        LogQuestionDeleted(msg.sender,question);
        return true;
    }
    
    
    