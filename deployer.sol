// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract deployer{
    address public _lastaddr;

    // deply contract by providing the creation_tx.input_data, start with 0x
    // to find the deployed addr, call _lastaddr after this.
    function deploy_input(bytes memory creation_tx_input_0x)payable public returns (address addr){
        assembly {
            addr := create(callvalue(),add(creation_tx_input_0x,0x20), mload(creation_tx_input_0x))
            if iszero(extcodesize(addr)) {revert(0,0)}
            sstore(_lastaddr.slot,addr)
        }
    }

    // deploy contract bytecode without setup any state variables, start with 0x
    // to find the deployed addr, call _lastaddr after this.
    function deploy_bin(bytes memory bin_0x)payable public returns (address addr){
        bytes memory inputbin = gen_creation(bin_0x);
        assembly {
            addr := create(callvalue(),add(inputbin,0x20), mload(inputbin))
            if iszero(extcodesize(addr)) {revert(0,0)}
            sstore(_lastaddr.slot,addr)
        }
    }

    /*
    push bin_len
    push dst_offset // random, currently 0x0123
    dup2
    push offset // the len of the creation part, 0x2a for now
    dup3
    codecopy (39)
    return (f3)
    */
    function gen_creation(bytes memory bin_0x) public pure returns(bytes memory fullbytes){
        bytes memory binlen = abi.encodePacked(bin_0x.length);
        fullbytes = bytes.concat(hex"7f", binlen, hex"61012381602a82", hex"39f3", bin_0x);
    }
    function get_codesize(address addr) public view returns(uint256 code_size){
        // bytes memory code;
        assembly {
            code_size := extcodesize(addr)
        }
    }
    function get_code(address addr) public view returns(bytes memory code ){
        assembly {
            // calc length
            let sz := extcodesize(addr)
            // malloc
            code := mload(0x40)
            // ceiling the next new slot pointer
            mstore(0x40, add(code, and(add(add(sz, 0x20), 0x1f), not(0x1f))))
            // set length
            mstore(code, sz)
            // set code
            extcodecopy(addr, add(code,0x20), 0, sz)
        }
    }

    function get_bin_size(bytes memory bin_0x) public pure returns(uint256){
        return bin_0x.length;
    }
    
}

