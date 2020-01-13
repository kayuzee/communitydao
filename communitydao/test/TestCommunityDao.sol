
pragma solidity ^0.5.00;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CommunityDAO.sol";

contract TestCommunityDAO {
    
    function testDeploymentIsFine() public {
        CommunityDAO cd = CommunityDAO(DeployedAddresses.CommunityDAO());
        uint256 whitelistfee = 10000000000000000; // in Wei, this is 0.01 ether

        Assert.equal(cd.whitelistfee(), whitelistfee, "Initial whitelisting fee should be 0.01 ether");
    }
}