// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    /* =============================================================
                            STEP 1
       Create the Campaign struct.
       It must store:
       - owner (address)
       - goal (uint256)
       - pledged amount (uint256)
       - start time (uint256)
       - end time (uint256)
       - claimed status (bool)
    ============================================================= */

    // TODO: Define struct here
    struct Campaign {
        address owner;
        uint256 goal;
        uint256 pledged;
        uint256 startAt;
        uint256 endAt;
        bool claimed;
    }

    /* =============================================================
                            STEP 2
       Create state variables:
       - campaignCount (uint256)
       - mapping from campaignId to Campaign
       - nested mapping to track how much each address pledged
    ============================================================= */

    // TODO: Declare campaignCount
    uint256 public campaignCount;
    // TODO: Declare campaigns mapping
    mapping(uint256 => Campaign) public campaigns;
    // it is a mapping of campaignId to another mapping of user address to pledged amount
    // TODO: Declare pledgedAmount nested mapping
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    /* =============================================================
                            STEP 3
       Create the create() function.
       It should:
       - Accept goal and duration
       - Increment campaignCount
       - Create a new Campaign struct
       - Set owner to msg.sender
       - Set pledged to 0
       - Set startAt to current block.timestamp
       - Set endAt to block.timestamp + duration
       - Set claimed to false
    ============================================================= */

    // TODO: Implement create()
    function create(uint256 goal, uint256 duration) external {
        require(goal > 0, "goal must be greater than 0");
        require(duration > 0, "duration must be greater than 0");

        campaignCount++;

        campaigns[campaignCount] = Campaign({
            owner: msg.sender,
            goal: goal,
            pledged: 0,
            startAt: block.timestamp,
            endAt: block.timestamp + duration,
            claimed: false
        });
    }

    /* =============================================================
                            STEP 4
       Create the pledge() function.
       It should:
       - Be payable
       - Take campaign ID
       - Check campaign has not ended
       - Increase total pledged
       - Increase user’s pledged amount
    ============================================================= */

    // TODO: Implement pledge()
    function pledge(uint256 campaignId) external payable {
        require(
            campaignId > 0 && campaignId <= campaignCount,
            "Invalid campaign ID"
        );
        Campaign storage campaign = campaigns[campaignId];

        require(campaign.endAt > block.timestamp, "Campaign has ended");
        require(msg.value > 0, "Pledge amount must be greater than 0");

        campaign.pledged += msg.value;
        pledgedAmount[campaignId][msg.sender] += msg.value;
    }

    /* =============================================================
                            STEP 5
       Create the claim() function.
       It should:
       - Allow only campaign owner
       - Require campaign ended
       - Require goal reached
       - Require not already claimed
       - Mark claimed = true
       - Transfer total pledged to owner
    ============================================================= */

    // TODO: Implement claim()
    function claim(uint256 campaignId) external {
        require(
            campaigns[campaignId].owner == msg.sender,
            "Not campaign owner"
        );
        require(
            campaignId > 0 && campaignId <= campaignCount,
            "Invalid campaign ID"
        );
        Campaign storage campaign = campaigns[campaignId];
        require(campaign.endAt <= block.timestamp, "Campaign has not ended");
        require(campaign.pledged >= campaign.goal, "Goal not reached");
        require(!campaign.claimed, "Already claimed");
        campaign.claimed = true;
        payable(campaign.owner).transfer(campaign.pledged);
    }

    /* =============================================================
                            STEP 6
       Create the refund() function.
       It should:
       - Require campaign ended
       - Require goal NOT reached
       - Get user pledged amount
       - Set user pledged amount to 0
       - Transfer ETH back to user
    ============================================================= */

    // TODO: Implement refund()
    function refund(uint256 campaignId) external {
        require(
            campaignId > 0 && campaignId <= campaignCount,
            "Invalid campaign ID"
        );
        Campaign storage campaign = campaigns[campaignId];
        require(campaign.endAt <= block.timestamp, "Campaign has not ended");
        require(campaign.pledged < campaign.goal, "Goal was reached");

        uint256 userPledged = pledgedAmount[campaignId][msg.sender];
        require(userPledged > 0, "No pledged amount to refund");

        pledgedAmount[campaignId][msg.sender] = 0;
        payable(msg.sender).transfer(userPledged);
    }
}
