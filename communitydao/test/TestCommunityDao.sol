
pragma solidity ^0.5.00;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CommunityDAO.sol";

contract TestCommunityDAO {
    CommunityDAO cd = CommunityDAO(DeployedAddresses.CommunityDAO());
    function testDeploymentIsFine() public {
        uint256 whitelistfee = 10000000000000000; // in Wei, this is 0.01 ether

        Assert.equal(cd.whitelistfee(), whitelistfee, "Initial whitelisting fee should be 0.01 ether");
    }
    function testZeroFee() public {
    uint256 submissionZeroFee = 1000; // in Wei, this is 0.0001 ether

    Assert.equal(cd.submissionZeroFee(), submissionZeroFee, "Zero submission fee should be 0.0001 ether");
    }
    //Can do better here
    function testisOwner() public { 

    Assert.equal(cd.isOwner(), false, "Deployer should be Owner");
    }

    function testZeroFee2() public {
    uint256 submissionZeroFee = 1000; // in Wei, this is 0.0001 ether

    Assert.equal(cd.submissionZeroFee(), submissionZeroFee, "Zero submission fee should be 0.0001 ether");
    }
    function testThrowFunctions() public {
            bool r;

            (r, ) = address(this).call(abi.encodePacked(this.IThrow1.selector));
            Assert.isFalse(r, "If this is true, something is broken!");

            (r, ) = address(this).call(abi.encodePacked(this.IThrow2.selector));
            Assert.isFalse(r, "What?! 1 is equal to 10?");
        }

    function IThrow1() public pure {
        revert("I will throw");
    }

    function IThrow2() public pure {
        require(1 == 10, "I will throw, too!");
    }
}