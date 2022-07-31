// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721UDS} from "UDS/tokens/ERC721UDS.sol";
import {AccessControlUDS} from "UDS/auth/AccessControlUDS.sol";
import {OwnableUDS} from "UDS/auth/OwnableUDS.sol";
import {PausableUDS} from "UDS/auth/PausableUDS.sol";
import {UUPSUpgrade} from "UDS/proxy/UUPSUpgrade.sol";
import {Initializable} from "UDS/auth/Initializable.sol";

error NotPauser();

contract SBTc is UUPSUpgrade, Initializable, OwnableUDS, AccessControlUDS, PausableUDS, ERC721UDS {
    /// @dev keccak256('PAUSER_ROLE')
    bytes32 public constant PAUSER_ROLE = 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a;

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

    function _authorizeUpgrade() internal override onlyOwner {}
}
