import React from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";
import { Flex, Box } from 'rimble-ui';
import LiteAccountData from "./components/LiteAccountData";
import Contract_Form from "./components/Contract_Form";
import SubmissionSearch from "./components/SubmissionSearch";
import ProposalSearch from "./components/ProposalSearch";
import logo from "./logo.png";
import Web3 from "web3";
export default ({ accounts }) => (

  <div className="App">
        

    <div >
      <img src={logo} alt="drizzle-logo" />
      <h1>CommunityDAO</h1>
      <p>The CommunityDAO is a Contract and interface that can be used for your community.</p>
      Web3 Call Test (Web3.Version): {Web3.version}
    
      <p></p>

    </div>

   <p></p>

      <p></p>
      <div className="normal">
    <Flex>
    <Box p={3} width={1 / 3} color="black" bg="white">
    <h2>You can use  CommunityDAO to</h2>
      <li>Add people (whitelist) to a group</li>
      <li>Create a idea (e.g Lets build a community garden')</li>
      <li>Submit this idea forward (e.g Proposal 1: Community Garden</li>
      <li>Members can vote for this proposal</li>
      <li>Have complete history and trackability for all proposals voted for</li> 
      <p></p>

    </Box>
    <Box p={3} width={1 / 3} color="black" bg="white"> 
    <h2>Step 1: Invite someone to the community</h2>
    <strong> Your ethereum address must be whitelisted to participate in our community</strong>
    <p> Only whitelisted members can whitelist</p>
    <p> The whitelist fee is</p> <ContractData contract="CommunityDAO" method="whitelistfee" /> wei
    <p></p>
    <strong>Please whitelist someone by entering their address below and clicking 'submit'</strong>
    <p></p>
      <Contract_Form contract="CommunityDAO" method="whitelistAddress" sendArgs={{ from: accounts[0], value: 100000000000000000, gas: 3141592 }}/>
      <p></p>
      <strong> We have </strong>
      <ContractData contract="CommunityDAO" method="whitelistedNumber" /> members
      <p></p>
    </Box>
    <Box p={3} width={1 / 3} color="blue" bg="white"> 
    <h2>Current Address</h2><AccountData accountIndex={0} units="ether" precision={3} />
      {/*Current Address: <LiteAccountData accountIndex={0}/>*/}
    </Box>
    </Flex>
  </div>
<p></p>
<p></p>
      <div className='normal'>
    <Flex>
    <Box p={3} width={1 / 3} color="black" bg="white">
      <h2>Step 2: Register a new community idea </h2>
      <p>Sorry, I am still learning - your submission has to be in hex (e.g 0x6e656f) :)</p>
      <p> Here are a couple of starters</p>
      <p>New Community Garden: 0x4e657720436f6d6d756e6974792047617264656e</p>
      <p>Add 500$ to member budget: 0x416464203530302420746f206d656d62657220627564676574 </p>
      <strong> Enter one of these below</strong>
      <p></p>
      <Contract_Form contract="CommunityDAO" method="createSubmission" sendArgs={{gas: 300000 }} />
      <p></p>
      Total Ideas: 
      <ContractData contract="CommunityDAO" method="getSubmissionCount" />
      <p></p>
    </Box>
    <Box p={3} width={1 / 3} color="blue" bg="white">
    <strong> Submitted ideas</strong>
      <p> These are the hashes of the submission content, along with the person who submitted</p>
      <p> We do this so we can keep a full array on the blockchain that is tamper proof</p>
      <ContractData contract="CommunityDAO" method="getAllSubmissionHashes" />
      <p></p>
    </Box>
    <Box p={3} width={1 / 3} color="black" bg="white">
    <strong>Idea Details </strong>
      <p></p>
      What do you mean you cant read a hash? Copy a hash from the left into the box and it will load the details
      <p> Only copying and pasting will work or you will have to refresh</p>
      <SubmissionSearch />
  </Box>

  </Flex>
  
  </div>
  
  <div className= "normal" >
  <Flex>
    <Box p={3} width={1/3} color="black" bg="white">
    <h2>Step 3: Create Community Proposal</h2>
    <p> See an idea you like? Put it up for a proposal</p>
    <p> Use the hash of the idea you like, add a description and then click submit</p>
    <p> For example, if you wanted a new community garden you would put the hash of '0xe8d82b8bb7bc5a536d4f0bb8578a3eb6567a023018fa203c7a37a7482ba14087' and a description of 'I vote for a new garden in Q4 2020'</p>
      <Contract_Form contract="CommunityDAO" method="createProposal" sendArgs={{gas: 300000 }}/>
    </Box>
    <Box p={2} width={1/3} color="black" bg="white">
    <h2>Step 4: Vote for CommunityProposal</h2>
    <p>Ideas are nothing if they dont come to fruition. Cast your vote here - you must be whitelisted</p>
    <p> There are two days to vote on a submission once it is created</p>
    <strong>3 votes are needed to pass</strong>>
    <p>A YES vote counts as +1, a NO vote counts as -1</p>
    <p> Ticking the box indicates a YES, leaving it blank indicates a NO</p>
      <ContractForm contract="CommunityDAO" method="vote" sendArgs={{gas: 300000 }}/>
      <p></p>
    </Box>
    <Box p={3} width={1/3} color="black" bg="white">
    <strong>Get proposal details</strong>
      <p>You can search by the ID of the proposals</p>
      <p></p>
     <ProposalSearch />
      </Box>
      </Flex>
  
  </div>

  </div>
);
