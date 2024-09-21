// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract fst_erc_721 is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event PSCCreate(address indexed owner, uint256 tokenId, string tokenURI);
    event PSCTransfer(address indexed from, address indexed to, uint256 tokenId);
    event PSCUpdateRole(uint256 tokenId, string Role);
    event PSCAddedToAllPSCs(uint256 tokenId);

    enum Role {Manufacture, Administrator, Consumer, Trader, Worker}

    mapping(uint256 => address) public PSCsOwner;
    mapping(uint256 => Role[]) public PSCsRole;
    mapping(address => Role) public addressToRole;
    uint256[] public AllPSCs;

    modifier OnlyPSCsOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Only PSCsOwner can access");
        _;
    }

    modifier OnlyManufacture() {
        require(getCurrentRole(msg.sender) == Role.Manufacture, "Only Manufacture can create PSCs");
        _;
    }

    constructor() ERC721("Product Safety Certificates", "PSC") Ownable() {}

    function getCurrentRole(address user) public view returns (Role) {
        uint256 tokenId = _tokenIds.current();
        uint256 rolesCount = PSCsRole[tokenId].length;

        if (rolesCount > 0) {
            return PSCsRole[tokenId][rolesCount - 1];
        } else {
            return Role.Manufacture;
        }
    }

    function register(address userAddress, Role newRole) public {
        // Require that the specified role is valid
        require(
            newRole == Role.Manufacture || 
            newRole == Role.Administrator || 
            newRole == Role.Consumer || 
            newRole == Role.Trader || 
            newRole == Role.Worker,
            "Invalid role"
        );

        // Check if the specified address has a role assigned
        require(addressToRole[userAddress] == Role(0), "Address is already registered");

        // Assign the specified role to the address
        addressToRole[userAddress] = newRole;
    }

    function login(address userAddress) public view returns (string memory) {
        // Check if the specified address is registered
        require(addressToRole[userAddress] != Role(0), "Address is not registered");

        // Retrieve the role associated with the specified address
        Role role = addressToRole[userAddress];

        // Convert the Role enum to a string
        string memory roleString;
        if (role == Role.Manufacture) {
            roleString = "Manufacturer";
        } else if (role == Role.Administrator) {
            roleString = "Administrator";
        } else if (role == Role.Consumer) {
            roleString = "Consumer";
        } else if (role == Role.Trader) {
            roleString = "Trader";
        } else if (role == Role.Worker) {
            roleString = "Worker";
        }

        // Return the role as a string
        return roleString;
    }



    function createPSC(address to) external OnlyManufacture returns (uint256) {
        _tokenIds.increment();
        uint256 newPSCsID = _tokenIds.current();
        _mint(to, newPSCsID);
        _setTokenURI(newPSCsID, "");  // You can set the URI as needed
        PSCsOwner[newPSCsID] = to;
        PSCsRole[newPSCsID].push(Role.Manufacture);

        AllPSCs.push(newPSCsID);

        emit PSCCreate(to, newPSCsID, "");  // You can provide the actual token URI
        emit PSCAddedToAllPSCs(newPSCsID);

        return newPSCsID;
    }

    function transferPSC(address to, uint256 tokenId, Role newRole) external OnlyPSCsOwner(tokenId) {
        require(msg.sender != to, "Cannot transfer to current owner");
        safeTransferFrom(msg.sender, to, tokenId);
        PSCsRole[tokenId].push(newRole);

        if (newRole == Role.Worker) {
            emit PSCTransfer(msg.sender, to, tokenId);
            emit PSCUpdateRole(tokenId, "Worker");
        } else if (newRole == Role.Trader) {
            emit PSCTransfer(msg.sender, to, tokenId);
            emit PSCUpdateRole(tokenId, "Trader");
        } else if (newRole == Role.Consumer) {
            emit PSCTransfer(msg.sender, to, tokenId);
            emit PSCUpdateRole(tokenId, "Consumer");
        }
    }

    function getPreviousOwner(uint256 tokenId) public view returns (address) {
        require(tokenId > 0 && tokenId <= _tokenIds.current(), "Invalid tokenId");

        if (tokenId > 1) {
            uint256 previousTokenId = tokenId - 1;
            return PSCsOwner[previousTokenId];
        } else {
            return owner();
        }
    }

    function getAllPSCs() public view returns (uint256[] memory) {
        return AllPSCs;
    }
}
