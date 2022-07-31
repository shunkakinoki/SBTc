// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Initializable} from "./Initializable.sol";

// ------------- storage

// keccak256("diamond.storage.pausable") == 0x6c12717fc0c7e094d0863d3779f70ed6b10509e4c31b62218121f564c04c42d9;
bytes32 constant DIAMOND_STORAGE_PAUSABLE = 0x6c12717fc0c7e094d0863d3779f70ed6b10509e4c31b62218121f564c04c42d9;

function s() pure returns (PausableDS storage diamondStorage) {
    assembly { diamondStorage.slot := DIAMOND_STORAGE_PAUSABLE } // prettier-ignore
}

struct PausableDS {
    bool paused;
}

/// @dev Requires `__Pausable_init` to be called in proxy
abstract contract PausableUDS is Initializable {
    event Paused(address account);
    event Unpaused(address account);

    function __Pausable_init() internal initializer {
        s().paused = false;
    }

    /* ------------- external ------------- */

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return s().paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        s().paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        s().paused = false;
        emit Unpaused(msg.sender);
    }

    /* ------------- modifier ------------- */

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }
}
