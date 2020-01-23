import React from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";
import { Card,Flex, Box } from 'rimble-ui';
import LiteAccountData from "./components/LiteAccountData";
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
      <Card bg="white" color="black" maxWidth={"700px"}>
      Current Address: <LiteAccountData accountIndex={0}/>
      </Card>
    </div>

    <div className="section">
        <Card bg="blue" color="white" maxWidth={"700px"}>
        <p>You can use  CommunityDAO to</p>
      <li>Add people (whitelist) to a group</li>
      <li>Create a idea (e.g Lets build a community garden')</li>
      <li>Submit this idea forward (e.g Proposal 1: Community Garden</li>
      <li>Members can vote for this proposal</li>
      <li>Have complete history and trackability for all proposals voted for</li>
      </Card>
    </div>

    <div className="section">
    <Flex>
    <Box p={2} width={1} color="white" bg="black">
      <h2>Active Account</h2>
      <AccountData accountIndex={0} units="ether" precision={3} />
      </Box> </Flex>
    </div>

      <div className = "section">
    <Flex>
    <Box p={3} width={1 / 2} color="salmon" bg="black">
      <strong>Register a new community idea </strong>
      <p>Sorry, I am still learning - your submission has to be in hex (e.g 0x6e656f) :)</p>
      <ContractForm contract="CommunityDAO" method="createSubmission" sendArgs={{gas: 300000 }} />
      Total Ideas: 
      <ContractData contract="CommunityDAO" method="getSubmissionCount" />
      <p></p>
    </Box>
    <Box p={3} width={1 / 2} color="white" bg="salmon">
    <strong>Invite someone to the community</strong>
    <p> Your ethereum address must be whitelisted to participate in our community</p>
    <p> Only whitelisted members can whitelist</p>
    <p> The whitelist fee is</p> <ContractData contract="CommunityDAO" method="whitelistfee" /> wei
    <p></p>
      <ContractForm contract="CommunityDAO" method="whitelistAddress" sendArgs={{ from: accounts[0], value: 100000000000000000, gas: 3141592 }}/>
      <p></p>
      <strong> We have </strong>
      <ContractData contract="CommunityDAO" method="whitelistedNumber" /> members
      <p></p>
    </Box>

  </Flex>
  
  </div>
  <div className= "section" >
    <Box p={3} width={1} color="salmon" bg="black">
      <strong> Submitted ideas</strong>
      <p> These are the hashes out the submissions</p>
      <ContractData contract="CommunityDAO" method="getAllSubmissionHashes" />
      <p></p>
    </Box>
    <Box p={2} width={1} color="salmon" bg="white"></Box>
    <Box p={3} width={1} color="salmon" bg="black">
    <strong>Idea Details </strong>
      <p></p>
      What do you mean you cant read a hash? Click on a hash on the left to see the submission details
      <SubmissionSearch />
      <p>Note: This retrieval is under development and is not fully functional - you are going to have to learn how to read a hash!(I havent figured out how to use React objects into Drizzle...yet)</p>
      </Box>
  
  </div>
  <div className = "section">
    <Flex>
    <Box p={3} width={1 / 2} color="salmon" bg="black">
    <strong>Create Community Proposal</strong>
    <p> See an idea you like? Put it up for a proposal</p>
      <ContractForm contract="CommunityDAO" method="createProposal" sendArgs={{gas: 300000 }}/>
      <p></p>
    </Box>
    <Box p={3} width={1 / 2} color="white" bg="salmon">
    <strong>Vote for CommunityProposal</strong>
    <p>Ideas are nothing if they dont come to fruition. Cast your vote here - you must be whitelisted</p>
      <ContractForm contract="CommunityDAO" method="vote" sendArgs={{gas: 300000 }}/>
      <p></p>
    </Box>
  </Flex>
  </div>
  <div className="section">
    <Card bg="blue" color="white" maxWidth={"700px"}>
      <strong>Get proposal details (beta - coming soon!)</strong>
      <p>Right now - this just shows for the first item in the index</p>
      <p></p>
      {/*<ContractData contract="CommunityDAO" method="proposals" methodArgs={[ 0 ]} /> */} 
      <ProposalSearch />
      
    </Card>
    </div> 

  </div>
);
