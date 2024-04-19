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
    using Strings for int96;

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

    constructor() ERC721("BalanceCraft", "BCR") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "BalanceCraft: No permission");
        _;
    }

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
    function withdraw(uint26 _amount) external {
        require(
            depositsByAddress[msg.sender] >= _amount,
            "BalanceCraft: Insufficient funds"
        );
        depositsByAddress[msg.sender] -= _amount;
        payable(owner).transfer(_amount);
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
        Levels level = _getLevel(totalDeposited);
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
            '{"trait_type": "Rank", "value": ',
            levelString,
            "}",
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
    function _getLevel(uint256 amount) internal pure returns (Levels) {
        if (amount >= 0 && amount < 15000 wei) {
            return Levels.Bronze;
        } else if (amount >= 15000 wei && amount < 30000 wei) {
            return Levels.Silver;
        } else if (amount >= 30000 wei && amount < 45000 wei) {
            return Levels.Gold;
        } else if (amount >= 45000 wei && amount < 60000 wei) {
            return Levels.Platinum;
        } else if (amount >= 60000 wei && amount < 75000 wei) {
            return Levels.Diamond;
        } else if (amount >= 75000 wei && amount < 90000 wei) {
            return Levels.Master;
        } else {
            return Levels.GrandMaster;
        }
    }

    function _levelToString(
        Levels level
    ) internal pure returns (string memory) {
        if (level == Levels.Bronze) {
            return "Bronze";
        } else if (level == Levels.Silver) {
            return "Silver";
        } else if (level == Levels.Gold) {
            return "Gold";
        } else if (level == Levels.Platinum) {
            return "Platinum";
        } else if (level == Levels.Diamond) {
            return "Diamond";
        } else if (level == Levels.Master) {
            return "Master";
        } else {
            return "GrandMaster";
        }
    }

    function _getImageUriForLevel(
        Levels _level
    ) internal pure returns (string memory) {
        return "";
    }
}
