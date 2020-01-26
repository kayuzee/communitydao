import Web3 from "web3";
import CommunityDAO from "./contracts/CommunityDAO.json"

const options = {
  web3: {
    block: false,
    customProvider: new Web3(window.web3.currentProvider),
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
