pragma solidity ^0.5.0;


//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol"; //If using remix, comment this and use line 4
import "openzeppelin-solidity/contracts/ownership/Ownable.sol"; //If using remix, comment this and use line 5
/** @title CommunityDAO */
contract CommunityDAO is Ownable {
    //Varaiables
    using SafeMath for uint256;
    mapping(address => bool) whitelist;
    uint256 public whitelistedNumber = 0;
    mapping(address => bool) blacklist;
    uint256 public proposalCount = 0;

    //Submission Fees
    uint256 public whitelistfee = 10000000000000000; // in Wei, this is 0.01 ether
    uint256 public submissionZeroFee = 1000; //ADDED

    // Events for changing fees
    event SubmissionCommissionChanged(uint256 newFee);
    event WhitelistFeeChanged(uint256 newFee);
    event SubmissionFeeChanged(uint256 newFee); //ADDED
    event Whitelisted(address addr, bool status);
    event Blacklisted(address addr, bool status);
    event SubmissionCreated(uint256 index, bytes content, address submitter);
    event ProposalAdded(uint256 id, uint8 typeFlag, bytes32 hash, string description, address submitter);
    event ProposalExecuted(uint256 id);
    event Voted(address voter, bool vote, string justification);
    mapping (bytes32 => Submission) public submissions;  

    //Structs
    struct Submission {
    bytes content;
    uint256 index;
    address submitter;
    }
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
    struct Vote {
    bool inSupport;
    address voter;
    string justification;
    }
    //Arrays
    Proposal[] public proposals;
    bytes32[] public submissionIndex;

    
        /** @dev Creates a hash of a input that can be used to create a proposal. Input is in Hex
            * @param _content Content in Hex format.
            */
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

     /** @dev Gets a few of the parameters from the Proposal struct
        * @param _proposalId ID of the proposal
        * @return description String of the description submitted when creating a proposal
        * @return votes The number of votes (currentResult) that a proposal has
        * @return passed Whether the proposal has been executed. This happens when the votes reach 3
        */
    function getProposal(uint256 _proposalId) public view returns (string memory description, int256 votes, bool passed ){
        require(proposals.length > 0, "Must have at least one proposal");
        return (proposals[_proposalId].description,proposals[_proposalId].currentResult, proposals[_proposalId].executed);
    }
    

    /** @dev allows the Owner to change the fees required for whitelisting, this can only be made lower
        * @param _fee Whitelisting fee
        */
    function changewhitelistfee(uint256 _fee) onlyOwner external {
        require(_fee < whitelistfee, "New fee must be lower than old fee.");
        whitelistfee = _fee;
        emit WhitelistFeeChanged(_fee);
    }
    /** @dev Allows owner to lower submission fee
        * @param _fee Submission fee
        */
    function lowerSubmissionFee(uint256 _fee) onlyOwner external {
        require(_fee < submissionZeroFee, "New fee must be lower than old fee.");
        submissionZeroFee = _fee;
        emit SubmissionFeeChanged(_fee);
    }
    
    /** @dev Whitelists an address. All whitelisted addresses can whitelist others.
        * @param _add address to add
        * TO DO: Blacklisting 
        */
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

     /** @dev Given a hash, returns the corresponding submission details (content) and submitter
        * @param hash hash created when a submission was created
        * @return content Content from submission - converted to a string
        * @return submitter Address that created the submission
        */
    function getSubmission(bytes32 hash) public view returns (string memory content, address submitter) {
        return (string(submissions[hash].content), submissions[hash].submitter);
    }

     /** @dev Gets all submission hashes
        * @return returns submissionIndex Array
        */
    function getAllSubmissionHashes() public view returns (bytes32[] memory) {
        return submissionIndex;
    }
     /** @dev Gets count of submissions
        */
    function getSubmissionCount() public view returns (uint256) {
        return submissionIndex.length;
    }
    
    /** @dev Voting function to vote on a proposal, must be whitelisted. Proposal executed when current result reaches 3
        * @param _proposalId Id index of proposal
        * @param _vote false = a NO vote, true = YES vote, this creates a counter for the currentresult
        * @param _description a extra field for a member to add a comment to their vote
        * @return returns submissionIndex Array
        */
    function vote(uint256 _proposalId, bool _vote, string memory _description) public returns (int256) {
        require(whitelist[msg.sender], "Must be whitelisted");
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
        p.currentResult = (_vote) ? p.currentResult + 1 : p.currentResult - 1;
        if (p.currentResult == 3) {
            p.executed = true; 
        } 
        emit Voted(msg.sender, _vote, _description);
        return p.currentResult;
        }
    
    /** @dev creates a proposal
        * @param _hash Hash of submission
        * @param _description Description of the proposal e.g 'New garden proposal Q4 2019'
        */
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
    /** @dev Fallback
        */
    function() external payable {

        if (!whitelist[msg.sender]) {
            whitelistAddress(msg.sender);
        } else {
            // buyTokens(msg.sender, msg.value);
        }
    }

}