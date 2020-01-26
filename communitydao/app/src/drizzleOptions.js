import Web3 from "web3";
import CommunityDAO from "./contracts/CommunityDAO.json"

const options = {
  web3: {
    block: false,
  customProvider: new Web3("ws://localhost:8545"), /* use window.web3.currentProvider for metamask */
  },
  contracts: [CommunityDAO],
  events: {
    CommunityDAO: ["Whitelisted","Blacklisted","SubmissionCommissionChanged","WhitelistFeeChanged","SubmissionFeeChanged","SubmissionCreated","ProposalAdded","ProposalExecuted","Voted"],
  },
  polls: {
    accounts: 1500,
  },
};

export default options;
