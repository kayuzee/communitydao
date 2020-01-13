const CommunityDAO= artifacts.require("CommunityDAO");

module.exports = function(deployer) {

  deployer.deploy(CommunityDAO);
};
