// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleToken is Ownable {
    // State variables
    // owner is already defined in the Ownable contract.
    mapping(address => uint256) public balances;
    mapping(address => bool) public denylisted;

    constructor() {
        // owner = msg.sender; is already defined in the Ownable contract.
        // Some non-zero token balance to the owner using balances.
        balances[owner()] = 1000;
    }

    // Modifier to make sure the sender is not denylisted.
    modifier not_denylisted() {
        require(!denylisted[msg.sender], "Error");
        _;
    }

    // Modifier to accept an uint argument to check whether the balance of the sender account has enough funds for transfer
    modifier at_least(uint256 amount) {
        require(balances[msg.sender] >= amount, "Error");
        _;
    }

    // Function to change a non-denylisted account to a denylisted account.
    function denylist(address account) public onlyOwner {
        denylisted[account] = true;
    }

    // Function transfer(address, uint) to accept the recipient's account address and token to transfer as arguments.
    // In addition, it's guarded by not_denylisted and at_least functions
    function transfer(address recipient, uint256 amount) public not_denylisted at_least(amount){
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
}
