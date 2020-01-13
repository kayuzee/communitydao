import expectThrow from './helpers/expectThrow';

const CommunityDAO = artifacts.require("CommunityDAO");

contract('CommunityDAO Test', async (accounts) => {

    it("should make sure environment is OK by checking that the first 3 accounts have over 20 eth", async () =>{
        assert.equal(web3.eth.getBalance(accounts[0]).toNumber() > 2e+19, true, "Account 0 has more than 20 eth");
        assert.equal(web3.eth.getBalance(accounts[1]).toNumber() > 2e+19, true, "Account 1 has more than 20 eth");
        assert.equal(web3.eth.getBalance(accounts[2]).toNumber() > 2e+19, true, "Account 2 has more than 20 eth");
    });

    it("should make the deployer the owner", async () => {
        let instance = await CommunityDAO.deployed();
        assert.equal(await instance.owner(), accounts[0]);
    });

    it("should let owner change fee and duration", async () => {
        let instance = await StoryDao.deployed();
        
        let newWhitelistFee = 1e+10; // 1 ether

        instance.changewhitelistfee(newWhitelistFee, {from: accounts[0]});

        assert.equal(await instance.whitelistfee(), newWhitelistFee);
    });

    it("should forbid non-owners from changing fee and duration", async () => {
        let instance = await CommunityDAO.deployed();
        
        let newWhitelistFee = 1e+10; // 1 ether

        await expectThrow(instance.changewhitelistfee(newWhitelistFee, {from: accounts[1]}));
    });

});