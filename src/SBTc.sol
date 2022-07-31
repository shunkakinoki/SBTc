// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721UDS} from "UDS/tokens/ERC721UDS.sol";
import {AccessControlUDS} from "UDS/auth/AccessControlUDS.sol";
import {OwnableUDS} from "UDS/auth/OwnableUDS.sol";
import {PausableUDS} from "UDS/auth/PausableUDS.sol";
import {UUPSUpgrade} from "UDS/proxy/UUPSUpgrade.sol";
import {Initializable} from "UDS/auth/Initializable.sol";

error NotPauser();
error TokenTransferWhilePaused();

contract SBTc is UUPSUpgrade, Initializable, OwnableUDS, AccessControlUDS, PausableUDS, ERC721UDS {
    /// @dev keccak256('PAUSER_ROLE')
    bytes32 public constant PAUSER_ROLE = 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a;
    /// EIP 5192: https://github.com/ethereum/EIPs/blob/7711f47ffe2969ab4462d848bca475e2ec857feb/EIPS/eip-5192.md
    bytes4 constant SOULBOUND_VALUE = bytes4(keccak256("soulbound")); // 0x9e7ed7f8;

    function init() public initializer {
        __Ownable_init();
        __ERC721_init("Soul Bount Token Compatible", "SBTC");
    }

    function tokenURI(uint256) public pure override returns (string memory) {
        return "URI";
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
    }

    function pause() public {
        if (!hasRole(PAUSER_ROLE, msg.sender)) revert NotPauser();

        _pause();
    }

    function unpause() public {
        if (!hasRole(PAUSER_ROLE, msg.sender)) revert NotPauser();

        _unpause();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlUDS, ERC721UDS)
        returns (bool)
    {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual override(ERC721UDS) {
        /// @dev Pause status won't block mint operation
        if (from != address(0) && paused()) revert TokenTransferWhilePaused();

        super.transferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual override(ERC721UDS) {
        /// @dev Pause status won't block mint operation
        if (from != address(0) && paused()) revert TokenTransferWhilePaused();

        super.safeTransferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) public virtual override(ERC721UDS) {
        /// @dev Pause status won't block mint operation
        if (from != address(0) && paused()) revert TokenTransferWhilePaused();

        super.safeTransferFrom(from, to, id, data);
    }

    function _authorizeUpgrade() internal override onlyOwner {}
}
