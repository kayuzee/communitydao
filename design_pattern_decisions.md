The following pattern decisions were used in the creation of CommunityDAO

## Access Restriction

The contract inherits the Ownable contract from OpenZepplin which allows for certain functions such as ownership and renouncing ownership to be restircted to a Owner address


## Guard Checks
Several Guard Checks are used to ensure that some functions are only run after certain conditions are met.

As an example, here is the createSubmission Function:

        ```function createSubmission(bytes calldata _content) external payable { 
        require(whitelist[msg.sender], "Must be whitelisted");
        require(!blacklist[msg.sender], "Must not be blacklisted");}```

This is also used in places such as when we want to retreive a proposal, which of course we can not do if not even one exists!
```require(proposals.length > 0, "Must have at least one proposal");```

