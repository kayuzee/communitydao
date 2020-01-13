import Web3 from "web3";
import CommunityDAO from "./contracts/CommunityDAO.json"

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:8545"),
  },
  contracts: [CommunityDAO],
  events: {
    CommunityDAO: ["SubmissionCreated"],
  },
  polls: {
    accounts: 1500,
  },
};

export default options;
