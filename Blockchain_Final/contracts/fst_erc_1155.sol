// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./fst_erc_20.sol";
import "./fst_erc_721.sol";

contract fst_erc_1155 is ERC1155, Ownable {
    address public erc20TokenAddress;
    address public erc721TokenAddress;

    // Event for minting ERC-1155 tokens
    event Minted(address indexed account, uint256 id, uint256 amount);

    // Event for reporting someone
    event Report(address indexed reporter, address indexed reported);
    event ReportProcessed(address indexed reporter, address indexed reported, string action);
    event BatchTransferPSC(address[] indexed to, uint256[] indexed pscIds, uint256[] indexed amounts);

    // List of reported addresses
    mapping(address => bool) public reportedAddresses;

    constructor() ERC1155("") Ownable() {
        erc20TokenAddress = 0x83f82B53ab79829205c692aB26D669333970e456;
        erc721TokenAddress = 0x3134a9d6E7b8Cf4b0AEd9c62778F86eF041Ff3C3;
    }

    // Function to report someone
    function report(address reported) external {
        require(reported != address(0), "Invalid address reported");
        require(msg.sender != reported, "Cannot report yourself");

        if (!reportedAddresses[reported]) {
            reportedAddresses[reported] = true;
            emit Report(msg.sender, reported);

            // Penalize the reported address by transferring 0.1% of their total FSP balance to the pool
            fst_erc_20 erc20Token = fst_erc_20(erc20TokenAddress);
            uint256 totalBalance = erc20Token.balanceOf(reported);
            uint256 penaltyAmount = (totalBalance * 1) / 100; // 1% of total balance
            if (penaltyAmount > 0) {
                erc20Token.TransferFSPsToPool(penaltyAmount);

                // You can implement additional actions based on your application's rules
                // For example, you can trigger further actions or emit additional events.
                // In this example, we're emitting an event to indicate that the report has been processed.
                emit ReportProcessed(msg.sender, reported, "Report submitted successfully. Penalty applied.");
            } else {
                emit ReportProcessed(msg.sender, reported, "Report submitted successfully, but no penalty applied (insufficient balance).");
            }
        } else {
            emit ReportProcessed(msg.sender, reported, "Already reported");
        }
    }

    function batchTransferPSC(address[] memory to, uint256[] memory pscIds, uint256[] memory amounts) external onlyOwner {
        require(to.length == pscIds.length && pscIds.length == amounts.length, "Arrays length mismatch");

        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], pscIds[i], amounts[i], "");
        }

        emit BatchTransferPSC(to, pscIds, amounts);
    }


    // Function to transfer ERC-20 tokens
    function transferERC20(address to, uint256 amount) external onlyOwner {
        fst_erc_20 erc20Token = fst_erc_20(erc20TokenAddress);
        erc20Token.transfer(to, amount);
    }

    // Function to transfer ERC-721 tokens
    function transferERC721(address to, uint256 tokenId) external onlyOwner {
        fst_erc_721 erc721Token = fst_erc_721(erc721TokenAddress);
        erc721Token.safeTransferFrom(address(this), to, tokenId);
    }

    // Other functions related to ERC-1155 can be added here
}
