// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Quiz is Ownable {
    struct Question {
        string questionText;
        string[] options;
        uint256 correctOption;
    }

    struct Participant {
        address participantAddress;
        uint256[] selectedOptions;
    }

    Question[] public questions;
    mapping(address => Participant) public participants;

    event QuestionAdded(uint256 indexed questionId);
    event ParticipantRegistered(address indexed participant);
    event AnswerSubmitted(address indexed participant, uint256 indexed questionId, uint256 selectedOption);

    // Function to add a new question (only owner can call this function)
    function addQuestion(string memory _questionText, string[] memory _options, uint256 _correctOption) public onlyOwner {
        require(_correctOption < _options.length, "Correct option must be within the range of options.");

        questions.push(Question({
            questionText: _questionText,
            options: _options,
            correctOption: _correctOption
        }));

        emit QuestionAdded(questions.length - 1);
    }

    // Remaining functions unchanged...
}
