pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


    /**
     * @dev Documentation
     * Functions:
     * - getGameItem: Allows users to get a game item by ID, checking if they have a soulbound token.
     * - mintSoulbound: Allows users to mint a soulbound token with a unique hash.
     * - _beforeTokenTransfer: Overrides the internal function to prevent transfers of the soulbound token.
     * Modifiers:
     * - onlyMainTokenOwner: Ensures that a function can only be called by the owner of the soulbound token.
     * Events:
     * - TransferSingle: Emitted when a single token is transferred.
     * - TransferBatch: Emitted when multiple tokens are transferred.
     * - ApprovalForAll: Emitted when the approval status for an operator is changed.
     * - URI: Emitted when the base URI is set.
     */


contract GameItems is ERC1155 {
     // Token IDs
    uint256 public constant MAINTOKEN = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;
    // Constructor to initialize the contract
    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        _mint(msg.sender, SILVER, 10**27, "");
        _mint(msg.sender, HAMMER, 1, "");
        _mint(msg.sender, SWORD, 10**9, "");
        _mint(msg.sender, SHIELD, 10**9, "");
    }
    // Function to get a game item by ID
    function getGameItem(uint _id) public{
        require(_id != 0, "cant mint Soulbound here");
        require(_id <= 4, "token doesnt exist");
         // Check if the user has a soulbound token
           require(balanceOf(msg.sender, MAINTOKEN) == 1 , "User should have a soulbound token");
        // Mint the requested item token
        _mint(msg.sender, _id, 1 , "");
    }
     // Function to mint a soulbound token with a given hash
    function mintSoulbound(string memory _hash) public{
        uint balanceOfUser = balanceOf(msg.sender, MAINTOKEN);
        //check to ensure user doesnt have soulbound before
        require(balanceOfUser == 0, "Already has Token");
         // Mint the soulbound token with the given hash
        _mint(msg.sender, MAINTOKEN, 1, bytes(_hash));
    }
     // Override _beforeTokenTransfer to prevent transfers of soulbound token
    function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
 ) view internal {
     // Check if the token is being transferred (from != address(0)) and if it's the soulbound token
   require(from == address(0) || to == address(0), "This a Soulbound     token. It cannot be transferred. It can only be burned by the token   owner.");
   // Check if both the sender and receiver have a soulbound token
   require(balanceOf(from, MAINTOKEN) == 1 && balanceOf(to, MAINTOKEN) == 1 , "User should have a soulbound token");
   
 }
}