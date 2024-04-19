// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/// @title SuperUnlockable - Stream to Unlock In-Game Items with ever-evolving Levels
/// @author Salman Dev
/// @notice This contract allows users to mint in-game items with ever-evolving levels while they stream SuperTokens
/// @dev All function calls are currently implemented without side effects
contract BalanceCraft is ERC721 {
    using Strings for uint256;
    using Strings for uint8;

    uint256 public currentTokenId = 0;

    mapping(address => uint256) public depositsByAddress;

    enum Levels {
        Bronze,
        Silver,
        Gold,
        Platinum,
        Diamond,
        Master,
        GrandMaster
    }

    constructor() ERC721("BalanceCraft", "BCR") {}

    /// @notice Withdraw the SuperToken funds from the contract
    /// @dev Only the owner can call this function
    receive() external payable {
        // check if sender already has a deposit, if so update the deposit else create a new deposit and mint nft
        if (depositsByAddress[msg.sender] > 0) {
            depositsByAddress[msg.sender] += msg.value;
        } else {
            depositsByAddress[msg.sender] = msg.value;
            _safeMint(msg.sender, currentTokenId);
            currentTokenId++;
        }
    }
    function withdraw(uint256 _amount) external {
        require(
            depositsByAddress[msg.sender] >= _amount,
            "BalanceCraft: Insufficient funds"
        );
        depositsByAddress[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    /// @notice Get the URI for a token
    /// @param tokenId The ID of the token
    /// @dev This function will return token the URI in json based on the flow opened by the token owner. overrides ERC721 tokenURI function
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return _getTokenURI(tokenId);
    }

    /// @notice Prepare and return the URI for a token(internal)
    /// @param _tokenId The ID of the token
    /// @dev This function will return token the URI in json based on the flow opened by the token owner
    function _getTokenURI(
        uint256 _tokenId
    ) internal view returns (string memory) {
        address tokenOwner = ownerOf(_tokenId);
        uint256 totalDeposited = depositsByAddress[tokenOwner];

        // Define the metadata attributes
        string memory name = string(
            abi.encodePacked("Crafter #", _tokenId.toString())
        );
        string
            memory description = "Unleash your financial powers with BalanceCraft collection. These in-game items showcase your ever-evolving powers, level, all while you send eth to the contract.";

        // Get the level of the user
        uint8 level = _getLevel(totalDeposited);
        string memory levelString = _levelToString(level);
        string memory imageURI = _getImageUriForLevel(level);

        // Create the JSON metadata object
        bytes memory json = abi.encodePacked(
            "{",
            '"name": "',
            name,
            '",',
            '"description": "',
            description,
            '",',
            '"image": "',
            imageURI,
            '",',
            '"attributes": [',
            '{"trait_type": "Power", "value": ',
            totalDeposited.toString(),
            "},",
            '{"trait_type": "Level", "value": ',
            level.toString(),
            "},",
            '{"trait_type": "Rank", "value": "',
            levelString,
            '"}',
            "]",
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(json)
                )
            );
    }

    /// @notice Internal function to determine the level based on the deposited amount
    /// @param amount The amount deposited by the user
    /// @return The level of the user
    function _getLevel(uint256 amount) internal pure returns (uint8) {
        if (amount >= 0 ether && amount < 0.1 ether) {
            return 0;
        } else if (amount >= 0.1 ether && amount < 0.2 ether) {
            return 1;
        } else if (amount >= 0.2 ether && amount < 0.3 ether) {
            return 2;
        } else if (amount >= 0.3 ether && amount < 0.4 ether) {
            return 3;
        } else if (amount >= 0.4 ether && amount < 0.6 ether) {
            return 4;
        } else if (amount >= 0.6 ether && amount < 0.9 ether) {
            return 5;
        } else {
            return 6;
        }
    }

    function _levelToString(
        uint8 _level
    ) internal pure returns (string memory) {
        if (_level == 0) {
            return "Bronze";
        } else if (_level == 1) {
            return "Silver";
        } else if (_level == 2) {
            return "Gold";
        } else if (_level == 3) {
            return "Platinum";
        } else if (_level == 4) {
            return "Diamond";
        } else if (_level == 5) {
            return "Master";
        } else {
            return "GrandMaster";
        }
    }

    function _getImageUriForLevel(
        uint8 _level
    ) internal pure returns (string memory) {
        return "";
    }
}
