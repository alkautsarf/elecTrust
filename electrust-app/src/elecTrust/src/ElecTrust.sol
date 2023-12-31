// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "forge-std/console.sol";

contract ElecTrustV4 {
    address public owner;
    string public electionName;
    uint256 public totalCandidates;
    uint256 public duration;

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping to store information about each candidate
    mapping(uint256 => Candidate) private candidates;

    // Mapping to keep track of whether an address has already voted
    mapping(address => bool) public hasVoted;

    // Event to notify when an Election is initialize
    event ElectionCreated(string electionName, uint256 totalCandidates);

    // Event to notify when a vote is cast
    event Voted(address indexed voter, uint256 candidateIndex);

    // Modifier to restrict certain functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Modifier to ensure that a voter can only vote once
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    // Modifier to ensure that vote take place in certain time
    modifier hasNotExpired() {
        require(block.timestamp < duration, "Voting has expired");
        _;
    }

    // Constructor to initialize the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to check the length of given name in parameter
    function _checkLen(string memory _name) private pure returns (bool) {
        bytes memory _bytesName = bytes(_name);
        return _bytesName.length != 0 ? true : false;
    }

    // Function to initialize the Election
    function setElection(string memory _name, uint256 _totalCandidates, uint256 _duration) external onlyOwner {
        require(_checkLen(_name), "Name is not valid");
        electionName = _name;
        totalCandidates = _totalCandidates;
        duration = block.timestamp + (_duration * 1 days);
        unchecked {
            for (uint256 i = 1; i <= totalCandidates; i++) {
                candidates[i] = Candidate("", 1);
            }
        }
        emit ElectionCreated(_name, _totalCandidates);
    }

    // Function to allow the owner to set the name of a candidate
    function setCandidateName(uint256 candidateIndex, string calldata _name) external onlyOwner {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        require(_checkLen(_name), "Name is not valid");

        candidates[candidateIndex].name = _name;
    }

    // Function to cast a vote for a candidate
    function vote(uint256 candidateIndex) external hasNotVoted hasNotExpired {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        hasVoted[msg.sender] = true;
        unchecked {
            candidates[candidateIndex].voteCount++;
        }
        emit Voted(msg.sender, candidateIndex);
    }

    // Function to get the total votes for a candidate
    function getVotes(uint256 candidateIndex) external view returns (uint256) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].voteCount - 1;
    }

    // Function to get the total votes for a candidate
    function getCandidateName(uint256 candidateIndex) external view returns (string memory) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].name;
    }
}

contract ElecTrustV3 {
    address public owner;
    string private _electionName;
    uint256 public totalCandidates;

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping to store information about each candidate
    mapping(uint256 => Candidate) private candidates;

    // Mapping to keep track of whether an address has already voted
    mapping(address => bool) public hasVoted;

    event ElectionCreated(string electionName, uint256 totalCandidates);
    // Event to notify when a vote is cast
    event Voted(address indexed voter, uint256 candidateIndex);

    // Modifier to restrict certain functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Modifier to ensure that a voter can only vote once
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    // Constructor to initialize the contract with the number of candidates
    constructor() {
        owner = msg.sender;
    }

    function setElection(string memory _name, uint256 _totalCandidates) external onlyOwner {
        require(_checkLen(_name), "Name is not valid");
        _electionName = _name;
        totalCandidates = _totalCandidates;
        unchecked {
            for (uint256 i = 1; i <= totalCandidates; i++) {
                candidates[i] = Candidate("", 1);
            }
        }
        emit ElectionCreated(_name, _totalCandidates);
    }

    // Function to check the length of given name in parameter
    function _checkLen(string memory _name) private pure returns (bool) {
        bytes memory _bytesName = bytes(_name);
        return _bytesName.length != 0 ? true : false;
    }

    function getName() external view returns (string memory) {
        return _electionName;
    }

    // Function to allow the owner to set the name of a candidate
    function setCandidateName(uint256 candidateIndex, string calldata _name) external onlyOwner {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        require(_checkLen(_name), "Name is not valid");

        candidates[candidateIndex].name = _name;
    }

    // Function to cast a vote for a candidate
    function vote(uint256 candidateIndex) external hasNotVoted {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");

        // Mark the sender as having voted
        hasVoted[msg.sender] = true;

        // Update vote count for the selected candidate
        unchecked {
            candidates[candidateIndex].voteCount++;
        }

        // Emit the Voted event
        emit Voted(msg.sender, candidateIndex);
    }

    // Function to get the total votes for a candidate
    function getVotes(uint256 candidateIndex) external view returns (uint256) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].voteCount - 1;
    }

    function getCandidateName(uint256 candidateIndex) external view returns (string memory) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].name;
    }
}

contract ElecTrustV2 {
    address public owner;
    string private _electionName;
    uint256 public totalCandidates;

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping to store information about each candidate
    mapping(uint256 => Candidate) private candidates;

    // Mapping to keep track of whether an address has already voted
    mapping(address => bool) public hasVoted;

    // Event to notify when a vote is cast
    event Voted(address indexed voter, uint256 candidateIndex);

    // Modifier to restrict certain functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Modifier to ensure that a voter can only vote once
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    // Constructor to initialize the contract with the number of candidates
    constructor(string memory _name, uint256 _totalCandidates) {
        require(_checkLen(_name), "Name is not valid");
        owner = msg.sender;
        _electionName = _name;
        totalCandidates = _totalCandidates;

        // Initialize candidates with empty names and 1 votes so first voters write from a non zero value to a non zero value
        unchecked {
            for (uint256 i = 1; i <= totalCandidates; i++) {
                candidates[i] = Candidate("", 1);
            }
        }
    }

    // Function to check the length of given name in parameter
    function _checkLen(string memory _name) private pure returns (bool) {
        bytes memory _bytesName = bytes(_name);
        return _bytesName.length != 0 ? true : false;
    }

    function getName() external view returns (string memory) {
        return _electionName;
    }

    // Function to allow the owner to set the name of a candidate
    function setCandidateName(uint256 candidateIndex, string calldata _name) external onlyOwner {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        require(_checkLen(_name), "Name is not valid");

        candidates[candidateIndex].name = _name;
    }

    // Function to cast a vote for a candidate
    function vote(uint256 candidateIndex) external hasNotVoted {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");

        // Mark the sender as having voted
        hasVoted[msg.sender] = true;

        // Update vote count for the selected candidate
        unchecked {
            candidates[candidateIndex].voteCount++;
        }

        // Emit the Voted event
        emit Voted(msg.sender, candidateIndex);
    }

    // Function to get the total votes for a candidate
    function getVotes(uint256 candidateIndex) external view returns (uint256) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].voteCount - 1;
    }

    function getCandidateName(uint256 candidateIndex) external view returns (string memory) {
        require(candidateIndex != 0 && candidateIndex <= totalCandidates, "Invalid candidate index");
        return candidates[candidateIndex].name;
    }
}

contract ElecTrust is Ownable(msg.sender) {
    enum Vote {
        Candidate1,
        Candidate2,
        Candidate3
    }

    mapping(Vote => uint256) private _votes;
    mapping(address => bool) private _voted;

    /**
     * @dev Initialize votes from non-zero values to optimize gas cost for voters.
     */
    constructor() {
        unchecked {
            _votes[Vote.Candidate1] = 1;
            _votes[Vote.Candidate2] = 1;
            _votes[Vote.Candidate3] = 1;
        }
    }

    function setVote(uint256 _vote) external {
        require(!_voted[msg.sender], "Already Voted");
        require(_vote > 0 && _vote < 4, "Cannot Vote For This Candidate");
        _voted[msg.sender] = true;

        unchecked {
            if (_vote == 1) {
                _votes[Vote.Candidate1]++;
            } else if (_vote == 2) {
                _votes[Vote.Candidate2]++;
            } else if (_vote == 3) {
                _votes[Vote.Candidate3]++;
            }
        }
    }

    function getVote() external view returns (uint256, uint256, uint256) {
        return (_votes[Vote.Candidate1] - 1, _votes[Vote.Candidate2] - 1, _votes[Vote.Candidate3] - 1);
    }
}
