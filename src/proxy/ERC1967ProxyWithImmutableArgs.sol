// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Library for deploying ERC1967 proxies with immutable args
/// @author phaze (https://github.com/0xPhaze/UDS)
/// @notice Inspired by (https://github.com/wighawag/clones-with-immutable-args)
/// @notice Supports up to 3 bytes32 "immutable" arguments
/// @dev Arguments are appended to calldata on any call
library LibERC1967ProxyWithImmutableArgs {
    /// @notice deploys an ERC1967 proxy with 1 immutable arg
    /// @param constructorArgs packed abi encoded constructor arguments:
    /// - address logic points to the implementation contract
    /// - bytes initCalldata is the encoded calldata used to call logic for initialization
    /// @param arg1_ first immutable arg
    /// @return addr address of the deployed proxy
    function deploy(bytes memory constructorArgs, bytes32 arg1_) internal returns (address addr) {
        bytes memory bytecode = abi.encodePacked(
            hex"60806040526040516103cb3803806103cb83398101604081905261002291610215565b61002c8282610033565b5050610318565b816001600160a01b03163b60000361005e576040516309ee12d560e01b815260040160405180910390fd5b6000826001600160a01b03166352d1902d6040518163ffffffff1660e01b8152600401602060405180830381865afa15801561009e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906100c291906102e3565b90506000805160206103ab83398151915281146100f2576040516303ed501d60e01b815260040160405180910390fd5b6040516001600160a01b038416907fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b90600090a281511561019e57600080846001600160a01b03168460405161014891906102fc565b600060405180830381855af49150503d8060008114610183576040519150601f19603f3d011682016040523d82523d6000602084013e610188565b606091505b50915091508161019b5780518082602001fd5b50505b50506000805160206103ab83398151915280546001600160a01b0319166001600160a01b0392909216919091179055565b634e487b7160e01b600052604160045260246000fd5b60005b838110156102005781810151838201526020016101e8565b8381111561020f576000848401525b50505050565b6000806040838503121561022857600080fd5b82516001600160a01b038116811461023f57600080fd5b60208401519092506001600160401b038082111561025c57600080fd5b818501915085601f83011261027057600080fd5b815181811115610282576102826101cf565b604051601f8201601f19908116603f011681019083821181831017156102aa576102aa6101cf565b816040528281528860208487010111156102c357600080fd5b6102d48360208301602088016101e5565b80955050505050509250929050565b6000602082840312156102f557600080fd5b5051919050565b6000825161030e8184602087016101e5565b9190910192915050565b6085806103266000396000f3fe608060405236600080377f",
            arg1_,
            hex"3652600160f81b60203601526000806021360160007f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d6000803e8080156073573d6000f35b3d6000fdfea164736f6c634300080d000a360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
            constructorArgs
        );

        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        if (addr.code.length == 0) revert();
    }

    /// @notice deploys an ERC1967 proxy with 2 immutable args
    /// @param constructorArgs packed abi encoded constructor arguments:
    /// - address logic points to the implementation contract
    /// - bytes initCalldata is the encoded calldata used to call logic for initialization
    /// @param arg1_ first immutable arg
    /// @param arg2_ second immutable arg
    /// @return addr address of the deployed proxy
    function deploy(
        bytes memory constructorArgs,
        bytes32 arg1_,
        bytes32 arg2_
    ) internal returns (address addr) {
        bytes memory bytecode = abi.encodePacked(
            hex"60806040526040516103f13803806103f183398101604081905261002291610215565b61002c8282610033565b5050610318565b816001600160a01b03163b60000361005e576040516309ee12d560e01b815260040160405180910390fd5b6000826001600160a01b03166352d1902d6040518163ffffffff1660e01b8152600401602060405180830381865afa15801561009e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906100c291906102e3565b90506000805160206103d183398151915281146100f2576040516303ed501d60e01b815260040160405180910390fd5b6040516001600160a01b038416907fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b90600090a281511561019e57600080846001600160a01b03168460405161014891906102fc565b600060405180830381855af49150503d8060008114610183576040519150601f19603f3d011682016040523d82523d6000602084013e610188565b606091505b50915091508161019b5780518082602001fd5b50505b50506000805160206103d183398151915280546001600160a01b0319166001600160a01b0392909216919091179055565b634e487b7160e01b600052604160045260246000fd5b60005b838110156102005781810151838201526020016101e8565b8381111561020f576000848401525b50505050565b6000806040838503121561022857600080fd5b82516001600160a01b038116811461023f57600080fd5b60208401519092506001600160401b038082111561025c57600080fd5b818501915085601f83011261027057600080fd5b815181811115610282576102826101cf565b604051601f8201601f19908116603f011681019083821181831017156102aa576102aa6101cf565b816040528281528860208487010111156102c357600080fd5b6102d48360208301602088016101e5565b80955050505050509250929050565b6000602082840312156102f557600080fd5b5051919050565b6000825161030e8184602087016101e5565b9190910192915050565b60ab806103266000396000f3fe608060405236600080377f",
            arg1_,
            hex"36527f",
            arg2_,
            hex"6020360152600260f81b60403601526000806041360160007f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d6000803e8080156099573d6000f35b3d6000fdfea164736f6c634300080d000a360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
            constructorArgs
        );

        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        if (addr.code.length == 0) revert();
    }

    /// @notice deploys an ERC1967 proxy with 3 immutable args
    /// @param constructorArgs packed abi encoded constructor arguments:
    /// - address logic points to the implementation contract
    /// - bytes initCalldata is the encoded calldata used to call logic for initialization
    /// @param arg1_ first immutable arg
    /// @param arg2_ second immutable arg
    /// @param arg3_ third immutable arg
    /// @return addr address of the deployed proxy
    function deploy(
        bytes memory constructorArgs,
        bytes32 arg1_,
        bytes32 arg2_,
        bytes32 arg3_
    ) internal returns (address addr) {
        bytes memory bytecode = abi.encodePacked(
            hex"608060405260405161041738038061041783398101604081905261002291610215565b61002c8282610033565b5050610318565b816001600160a01b03163b60000361005e576040516309ee12d560e01b815260040160405180910390fd5b6000826001600160a01b03166352d1902d6040518163ffffffff1660e01b8152600401602060405180830381865afa15801561009e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906100c291906102e3565b90506000805160206103f783398151915281146100f2576040516303ed501d60e01b815260040160405180910390fd5b6040516001600160a01b038416907fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b90600090a281511561019e57600080846001600160a01b03168460405161014891906102fc565b600060405180830381855af49150503d8060008114610183576040519150601f19603f3d011682016040523d82523d6000602084013e610188565b606091505b50915091508161019b5780518082602001fd5b50505b50506000805160206103f783398151915280546001600160a01b0319166001600160a01b0392909216919091179055565b634e487b7160e01b600052604160045260246000fd5b60005b838110156102005781810151838201526020016101e8565b8381111561020f576000848401525b50505050565b6000806040838503121561022857600080fd5b82516001600160a01b038116811461023f57600080fd5b60208401519092506001600160401b038082111561025c57600080fd5b818501915085601f83011261027057600080fd5b815181811115610282576102826101cf565b604051601f8201601f19908116603f011681019083821181831017156102aa576102aa6101cf565b816040528281528860208487010111156102c357600080fd5b6102d48360208301602088016101e5565b80955050505050509250929050565b6000602082840312156102f557600080fd5b5051919050565b6000825161030e8184602087016101e5565b9190910192915050565b60d1806103266000396000f3fe608060405236600080377f",
            arg1_,
            hex"36527f",
            arg2_,
            hex"60203601527f",
            arg3_,
            hex"6040360152600360f81b60603601526000806061360160007f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d6000803e80801560bf573d6000f35b3d6000fdfea164736f6c634300080d000a360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
            constructorArgs
        );

        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        if (addr.code.length == 0) revert();
    }

    /// @notice Reads an immutable arg with type uint256
    /// @param argOffset The offset of the arg in the packed data
    /// @param argLen The bytes length of the arg in the packed data
    /// @return arg The arg value
    function getArg(uint256 argOffset, uint256 argLen) internal pure returns (uint256 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(sub(256, shl(3, argLen)), calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Reads an immutable arg with type bytes32
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgBytes32(uint256 argOffset) internal pure returns (bytes32 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := calldataload(add(offset, argOffset))
        }
    }

    /// @notice Reads an immutable arg with type address
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgAddress(uint256 argOffset) internal pure returns (address arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(96, calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Reads an immutable arg with type uint256
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgUint256(uint256 argOffset) internal pure returns (uint256 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := calldataload(add(offset, argOffset))
        }
    }

    /// @notice Reads an immutable arg with type uint128
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgUint128(uint256 argOffset) internal pure returns (uint128 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(128, calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Reads an immutable arg with type uint64
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgUint64(uint256 argOffset) internal pure returns (uint64 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(192, calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Reads an immutable arg with type uint40
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgUint40(uint256 argOffset) internal pure returns (uint40 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(216, calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Reads an immutable arg with type uint8
    /// @param argOffset The offset of the arg in the packed data
    /// @return arg The arg value
    function getArgUint8(uint256 argOffset) internal pure returns (uint8 arg) {
        uint256 offset = getImmutableArgsOffset();
        assembly {
            arg := shr(248, calldataload(add(offset, argOffset)))
        }
    }

    /// @notice Gets the starting location in bytes in calldata for immutable args
    /// @return offset calldata bytes offset for immutable args
    function getImmutableArgsOffset() internal pure returns (uint256 offset) {
        assembly {
            let numArgs := shr(248, calldataload(sub(calldatasize(), 1)))
            offset := sub(sub(calldatasize(), 1), mul(numArgs, 0x20))
        }
    }
}

// // The bytecode is obtained from:
// import "./ERC1967Proxy.sol";
//
// bytes32 constant arg = 0xa88888888888888888888888888888888888888888888888888888888888888a;
//
// contract ERC1967ProxyWithConstantArgs is ERC1967 {
//     constructor(address logic, bytes memory initCalldata) payable {
//         _upgradeToAndCall(logic, initCalldata);
//     }
//
//     fallback() external payable {
//         assembly {
//             calldatacopy(0, 0, calldatasize())
//
//             mstore(calldatasize(), arg)
//             mstore(add(calldatasize(), 0x20), arg)
//             mstore(add(calldatasize(), 0x40), arg)
//             mstore(add(calldatasize(), 0x60), shl(248, 3))
//
//             let success := delegatecall(
//                 gas(),
//                 sload(ERC1967_PROXY_STORAGE_SLOT),
//                 0,
//                 add(calldatasize(), 0x61),
//                 0,
//                 0
//             )
//
//             returndatacopy(0, 0, returndatasize())
//
//             switch success
//             case 0 {
//                 revert(0, returndatasize())
//             }
//             default {
//                 return(0, returndatasize())
//             }
//         }
//     }
// }
