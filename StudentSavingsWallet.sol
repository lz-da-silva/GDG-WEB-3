// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentSavingsWallet {

    struct Transaction {
        address user;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => uint256) private balances;
    Transaction[] public transactions;
    uint256 public totalDeposits;

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        transactions.push(Transaction(msg.sender, msg.value, block.timestamp));
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        totalDeposits -= amount;
        transactions.push(Transaction(msg.sender, amount, block.timestamp));

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }
}
