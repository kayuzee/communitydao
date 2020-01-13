pragma solidity ^0.5.0;

//import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol"; //OLD
//import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol"; //OLD
//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
contract CommunityDAO is Ownable {
    using SafeMath for uint256;

    mapping(address => bool) whitelist;
    uint256 public whitelistedNumber = 0;
    mapping(address => bool) blacklist;
    event Whitelisted(address addr, bool status);
    event Blacklisted(address addr, bool status);

    //Submission Fees
    //TO DO: Only for actual submission and goes to community development pool
    
    uint256 public whitelistfee = 10000000000000000; // in Wei, this is 0.01 ether
    uint256 public submissionZeroFee = 1000; //ADDED

    // Events for changing fees
    event SubmissionCommissionChanged(uint256 newFee);
    event WhitelistFeeChanged(uint256 newFee);
    event SubmissionFeeChanged(uint256 newFee); //ADDED

    uint256 public durationDays = 21; // duration of story's chapter in days
    uint256 public durationSubmissions = 1000; // duration of story's chapter in entries
    
    struct Submission {
    bytes content;
    uint256 index;
    address submitter;
    }
    
    event SubmissionCreated(uint256 index, bytes content, address submitter);
    mapping (bytes32 => Submission) public submissions; //REORG
    bytes32[] public submissionIndex; //REORG
    
    
    // Structs for Voting function
    struct Proposal {
    string description;
    bool executed;
    int256 currentResult;
    uint8 typeFlag; // 1 = delete
    bytes32 target; // ID of the proposal target. I.e. flag 1, target XXXXXX (hash) means proposal to delete submissions[hash]
    uint256 creationDate;
    uint256 deadline;
    mapping (address => bool) voters;
    Vote[] votes;
    address submitter;
    }

    Proposal[] public proposals;
    uint256 proposalCount = 0;
    event ProposalAdded(uint256 id, uint8 typeFlag, bytes32 hash, string description, address submitter);
    event ProposalExecuted(uint256 id);
    event Voted(address voter, bool vote, string justification);
    
    struct Vote {
        bool inSupport;
        address voter;
        string justification;
    }
    

    // TO FIX? Bytes as call data needs to be put in a special way https://ethereum.stackexchange.com/questions/48092/solidity-error-when-encoding-arguments-to-call-a-function-with-bytes32-type-para
    function createSubmission(bytes calldata _content) external payable { 
        require(whitelist[msg.sender], "Must be whitelisted");
        require(!blacklist[msg.sender], "Must not be blacklisted");
        //uint256 fee = calculateSubmissionFee();
        //require(msg.value >= fee, "Fee for submitting an entry must be sufficient.");
    
        bytes32 hash = keccak256(abi.encodePacked(_content, block.number));
        //require(!submissions[hash].exists, "Submission must not already exist in same block!"); //??
    
        submissions[hash] = Submission(
            _content,
            submissionIndex.push(hash),
            msg.sender
        );
    
        emit SubmissionCreated(
            submissions[hash].index,
            submissions[hash].content,
            submissions[hash].submitter
        );
    
        //nonDeletedSubmissions += 1;
    }

    // Functions to change fees

    function changewhitelistfee(uint256 _fee) onlyOwner external {
        require(_fee < whitelistfee, "New fee must be lower than old fee.");
        whitelistfee = _fee;
        emit WhitelistFeeChanged(_fee);
    }

    function lowerSubmissionFee(uint256 _fee) onlyOwner external {
        require(_fee < submissionZeroFee, "New fee must be lower than old fee.");
        submissionZeroFee = _fee;
        emit SubmissionFeeChanged(_fee);
    }

    function changeDurationDays(uint256 _days) onlyOwner external {
        require(_days >= 1);
        durationDays = _days;
    }

    function changeDurationSubmissions(uint256 _subs) onlyOwner external {
        require(_subs > 99);
        durationSubmissions = _subs;
    }
    
     // Functions to Whitelist address
     //TO DO - Blacklisting/ rmeoving? 
    function whitelistAddress(address _add) public payable {
        require(!whitelist[_add], "Candidate must not be whitelisted.");
        require(!blacklist[_add], "Candidate must not be blacklisted.");
        require(msg.value >= whitelistfee, "Sender must send enough ether to cover the whitelisting fee.");
    
        whitelist[_add] = true;
        whitelistedNumber++;
        emit Whitelisted(_add, true);
    
        if (msg.value > whitelistfee) {
            // buyTokens(_add, msg.value.sub(whitelistfee));
        }
    }
    
    // Get indexes/submission info
    function getSubmission(bytes32 hash) public view returns (bytes memory content, address submitter) {
        return (submissions[hash].content, submissions[hash].submitter);
    }

    function getAllSubmissionHashes() public view returns (bytes32[] memory) {
        return submissionIndex;
    }

    function getSubmissionCount() public view returns (uint256) {
        return submissionIndex.length;
    }
    
    //Voting function
    function vote(uint256 _proposalId, bool _vote, string memory _description) public returns (int256) {
        //require(whitelist[msg.sender], "Must be whitelisted");
        //require(!blacklist[msg.sender], "Must not be blacklisted");
    
        Proposal storage p = proposals[_proposalId];
    
        require(p.executed == false, "Proposal must not have been executed already.");
        require(p.deadline > now, "Proposal must not have expired.");
        require(p.voters[msg.sender] == false, "User must not have already voted.");
    
        uint256 voteid = p.votes.length++;
        Vote storage pvote = p.votes[voteid];
        pvote.inSupport = _vote;
        pvote.justification = _description;
        pvote.voter = msg.sender;
    
        p.voters[msg.sender] = true;
    
        //p.currentResult = (_vote) ? p.currentResult + int256(_votePower) : p.currentResult - int256(_votePower); //TO FIX
        p.currentResult = (_vote) ? p.currentResult + 1 : p.currentResult - 1; // IS THIS THE RIGHT WAY TO COUNT FROM BOOL?
        emit Voted(msg.sender, _vote, _description);
        return p.currentResult;
        }
    
    //Proposal function
    
    function createProposal(bytes32 _hash, string memory _description) public {

        //require(submissionExists(_hash), "Submission must exist to be deletable");

        uint256 proposalId = proposals.length++;
        Proposal storage p = proposals[proposalId];
        p.description = _description;
        p.executed = false;
        p.creationDate = now;
        p.submitter = msg.sender;
        p.typeFlag = 1; //could be updated in future to have more options
        p.target = _hash;

        p.deadline = now + 2 days;

        emit ProposalAdded(proposalId, 1, _hash, _description, msg.sender);
        proposalCount = proposalId + 1;
    }
    
    //Fallback
    function() external payable {

        if (!whitelist[msg.sender]) {
            whitelistAddress(msg.sender);
        } else {
            // buyTokens(msg.sender, msg.value);
        }
    }

}