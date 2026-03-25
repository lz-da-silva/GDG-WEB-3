// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {CrowdFund} from "../src/CrowdFund.sol";

contract CrowdFundTest is Test {
    CrowdFund crowdFund;

    address owner = address(1);
    address user = address(2);

    function setUp() public {
        crowdFund = new CrowdFund();
    }

    function testCreateCampaign() public {
        vm.prank(owner);
        crowdFund.create(1 ether, 1 days);

        (
            address campaignOwner,
            uint256 goal,
            uint256 pledged,
            uint256 startAt,
            uint256 endAt,
            bool claimed
        ) = crowdFund.campaigns(1);

        assertEq(campaignOwner, owner);
        assertEq(goal, 1 ether);
        assertEq(pledged, 0);
        assertEq(claimed, false);
    }

    function testPledge() public {
        vm.prank(owner);
        crowdFund.create(1 ether, 1 days);

        vm.deal(user, 1 ether);

        vm.prank(user);
        crowdFund.pledge{value: 0.5 ether}(1);

        uint256 pledged = crowdFund.pledgedAmount(1, user);

        assertEq(pledged, 0.5 ether);
    }

    function testRefund() public {
        vm.prank(owner);
        crowdFund.create(5 ether, 1 days);

        vm.deal(user, 1 ether);

        vm.prank(user);
        crowdFund.pledge{value: 1 ether}(1);

        vm.warp(block.timestamp + 2 days);

        vm.prank(user);
        crowdFund.refund(1);

        uint256 pledged = crowdFund.pledgedAmount(1, user);

        assertEq(pledged, 0);
    }
}
