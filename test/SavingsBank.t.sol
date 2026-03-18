// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SavingsBank.sol";
contract SavingsBankTest is Test {
    SavingsBank public bank;
    address public user = address(0x1);

    function setUp() public {
        bank = new SavingsBank();
        vm.deal(user, 10 ether);
    }

    function testDepositAndBalance() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        assertEq(bank.getBalance(user), 1 ether); // Use getBalance(user) instead
        assertEq(bank.getTotalDeposits(), 1 ether);
    }

    function testCannotWithdrawTooMuch() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Insufficient balance");
        bank.withdraw(2 ether);
    }

    function testWithdrawalWorks() public {
        vm.prank(user);
        bank.deposit{value: 2 ether}();

        vm.prank(user);
        bank.withdraw(1 ether);

        assertEq(bank.getBalance(user), 1 ether); // Use getBalance(user) instead
        assertEq(bank.getTotalDeposits(), 1 ether);
    }
}
