// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20UDS, s as erc20DS} from "./ERC20UDS.sol";

// ------------- storage

// keccak256("diamond.storage.erc20.reward") == 0x2bf76f1229f14879252da90846a528ce52c56d0ade153f3ef6c5b45141fb99c9;
bytes32 constant DIAMOND_STORAGE_ERC20_REWARD = 0x2bf76f1229f14879252da90846a528ce52c56d0ade153f3ef6c5b45141fb99c9;

function s() pure returns (ERC20RewardDS storage diamondStorage) {
    assembly { diamondStorage.slot := DIAMOND_STORAGE_ERC20_REWARD } // prettier-ignore
}

struct UserData {
    uint216 multiplier;
    uint40 lastClaimed;
}

struct ERC20RewardDS {
    mapping(address => UserData) userData;
}

/// @title ERC20Reward (Upgradeable Diamond Storage, ERC20 compliant)
/// @author phaze (https://github.com/0xPhaze/UDS)
/// @notice Allows for ERC20 reward accrual
/// @notice at a rate of rewardDailyRate() * multiplier[user] per day
/// @notice Tokens are automatically claimed before any multiplier update
abstract contract ERC20RewardUDS is ERC20UDS {
    /* ------------- virtual ------------- */

    function rewardEndDate() public view virtual returns (uint256);

    function rewardDailyRate() public view virtual returns (uint256);

    /* ------------- view ------------- */

    function totalBalanceOf(address owner) public view virtual returns (uint256) {
        return ERC20UDS.balanceOf(owner) + pendingReward(owner);
    }

    function pendingReward(address owner) public view returns (uint256) {
        UserData storage userData = s().userData[owner];

        return _calculateReward(userData.multiplier, userData.lastClaimed);
    }

    /* ------------- internal ------------- */

    function _calculateReward(uint256 multiplier, uint256 lastClaimed) internal view virtual returns (uint256) {
        if (multiplier == 0) return 0;

        uint256 end = rewardEndDate();

        uint256 timestamp = block.timestamp;

        if (lastClaimed > end) return 0;
        else if (timestamp > end) timestamp = end;

        // if multiplier > 0 then lastClaimed > 0
        // because _claimReward must have been called
        return ((timestamp - lastClaimed) * multiplier * rewardDailyRate()) / 1 days;
    }

    function _claimReward(address owner) internal virtual {
        UserData storage userData = s().userData[owner];

        uint256 multiplier = userData.multiplier;
        uint256 lastClaimed = userData.lastClaimed;

        if (multiplier != 0 || lastClaimed == 0) {
            if (multiplier != 0) {
                uint256 amount = _calculateReward(multiplier, lastClaimed);

                _mint(owner, amount);
            }

            s().userData[owner].lastClaimed = uint40(block.timestamp);
        }
    }

    function _increaseRewardMultiplier(address owner, uint216 quantity) internal {
        _claimReward(owner);

        s().userData[owner].multiplier += quantity;
    }

    function _decreaseRewardMultiplier(address owner, uint216 quantity) internal {
        _claimReward(owner);

        s().userData[owner].multiplier -= quantity;
    }
}
