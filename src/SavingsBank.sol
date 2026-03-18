// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SavingsBank {
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    mapping(address => uint256) public balances;
    uint256 public totalDeposits;

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");

        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        totalDeposits -= amount;

        emit Withdrawal(msg.sender, amount);

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    function getTotalDeposits() external view returns (uint256) {
        return totalDeposits;
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
