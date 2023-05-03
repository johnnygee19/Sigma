// SPDX-License-Identifier: MIT

pragma solidity ^0.4.17;

import './ERC20.sol';

contract Sigma is ERC20 {
    /*
    `address payable` was added in Solidity 0.5.0 and prior to this release, `address` type
    worked as `address payable`.
    See https://ethereum.stackexchange.com/questions/64108/whats-the-difference-between-address-and-address-payable
    */
    address public owner;
    /*
    Block reward refers to the cryptocurrency rewarded to a miner when they successfully
    validate a new block.
    */
    uint256 public blockReward;
    uint256 _capacity;

    constructor(uint256 initialSupply, uint256 capacity, uint256 _blockReward) ERC20("Sigma", "SGM") {
        /*
        You can call this contract's internal functions from the constructor, but
        not external functions. Functions can be accessed directly or through `this.f`.
        */
	    owner = msg.sender;
	    _capacity = capacity;
        mint(msg.sender, initialSupply * (10 ** decimals()));
	    blockReward = _blockReward * (10 ** decimals());
    }

    function mint(address account, uint256 amount) internal {
        // Add gate checks.
        require(account != 0, "Cannot mint tokens to the zero address.");
	    require(_totalSupply + amount <= _capacity, "Cannot mint anymore tokens, capacity has been reached.");
        _totalSupply = _totalSupply + amount;
        _balances[account] = _balances[account] + amount;
        
        // Minting tokens from the zero address to the account.
        emit Transfer(address(0), account, amount);
    }

    function mintBlockReward() internal {
        mint(block.coinbase, blockReward);
    }

    function beforeTokenTransfer(address from, address to, uint256 value) internal {
        // Add comment and finish watching video
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            mintBlockReward();
        }
    }

    /*
    The burn address is known as the "zero address" because it has a 0 balance and
    cannot be accessed by anyone. When Ethereum tokens are sent to the burn address, they are
    effectively removed from circulation and cannot be used or accessed by anyone in the
    future.
    */
    function burn(address account, uint256 amount) internal {
        // Add gate checks.
        require(account != 0, "Cannot use the burn address as the account you're burning the tokens from.");
        require(_balances[account] >= amount, "Insufficient funds.");

        _totalSupply = _totalSupply - amount;
        _balances[account] = _balances[account] - amount;

        // address(0) is the address that you send burned tokens to.
        emit Transfer(account, address(0), amount);
    }

    // selfdestruct is a keyword in Solidity that is used when developers want to terminate a contract.
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
}