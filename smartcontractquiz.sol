// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuizGame {
    struct Question {
        string question;
        string answer; // Correct answer
        uint256 reward; // Reward for the correct answer
    }

    Question[] public questions;
    mapping(address => uint256) public rewards;
    mapping(address => mapping(uint256 => bool)) public answered;

    event QuestionAdded(uint256 questionId, string question);
    event AnswerSubmitted(address indexed player, uint256 questionId, bool correct);
    event RewardClaimed(address indexed player, uint256 amount);

    // Add a new question to the quiz
    function addQuestion(string memory _question, string memory _answer, uint256 _reward) public {
        questions.push(Question(_question, _answer, _reward));
        emit QuestionAdded(questions.length - 1, _question);
    }

    // Submit an answer for a specific question
    function submitAnswer(uint256 _questionId, string memory _answer) public {
        require(_questionId < questions.length, "Question does not exist");
        require(!answered[msg.sender][_questionId], "You already answered this question");

        answered[msg.sender][_questionId] = true;
        if (keccak256(abi.encodePacked(_answer)) == keccak256(abi.encodePacked(questions[_questionId].answer))) {
            rewards[msg.sender] += questions[_questionId].reward;
            emit AnswerSubmitted(msg.sender, _questionId, true);
        } else {
            emit AnswerSubmitted(msg.sender, _questionId, false);
        }
    }

    // Claim rewards for correct answers
    function claimReward() public {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit RewardClaimed(msg.sender, amount);
    }

    // Function to fund the contract with Ether
    receive() external payable {}

    // Function to withdraw funds by the contract owner (if needed)
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
