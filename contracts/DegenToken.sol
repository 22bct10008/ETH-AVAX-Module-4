// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, ERC20Burnable, Ownable {

    mapping(uint256 => uint256) private itemPrices;

    constructor() ERC20("Degen", "DGN") {
        itemPrices[1] = 100;
        itemPrices[2] = 50;
        itemPrices[3] = 20;
    }

    function mintDegen(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function getDegenBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferDegenTokens(address recipient, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transferFrom(msg.sender, recipient, amount);
    }

    function burnDegen(address account, uint256 amount) external {
        require(balanceOf(account) >= amount, "Insufficient balance");
        _burn(account, amount);
    }

    function exploreItems() public pure returns (string[] memory) {
        string[] memory items = new string[](3);
        items[0] = "1. Digital Asserts - 100 Tokens";
        items[1] = "2. NFTs - 50 Tokens";
        items[2] = "3. FRX Tokens - 20 Tokens";
        return items;
    }

    function redeemItem(uint256 choice) external payable {
        uint256 itemPrice = itemPrices[choice];
        require(itemPrice > 0, "Invalid choice");

        require(balanceOf(msg.sender) >= itemPrice, "Insufficient balance");

        _transfer(msg.sender, owner(), itemPrice);
    }
}
