// SPDX-License-Identifier: MIT

pragma solidity ^0.4.17;

import './IERC20.sol';

contract ERC20 is IERC20 {
    /*
    Internal state variables can only be accessed from within the contract they are
    defined in and in derived contracts. They cannot be accessed externally. This is
    the default visibility level for state variables.

    Private state variables are like internal ones but they are not visible in derived
    contracts.
    */

    // Use a trailing underscore to avoid naming collisions
    string _name;
    string _symbol;
    uint8 _decimals;
    uint256 _totalSupply;
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowed;

    constructor(string name, string symbol) {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    function name() public view returns (string) {
        return _name;
    }

    function symbol() public view returns (string) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(value <= _balances[msg.sender], "Insufficient funds.");
        require(to != address(0), "Recipient can't be zero address.");

        _balances[msg.sender] = _balances[msg.sender] - value;
        _balances[to] = _balances[to] + value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] = _balances[from] - value;
        _balances[to] = _balances[to] + value;
        _allowed[from][msg.sender] = _allowed[from][msg.sender] - value;

        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        require(spender != address(0), "Spender can't be the zero address.");

        _allowed[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256 remaining) {
        return _allowed[owner][spender];
    }
}