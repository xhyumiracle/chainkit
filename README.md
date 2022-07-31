# chainkit

## deployer.sol
Helper contract to support customize deployment
- deploy_input: deploy contract by providing the input bytecode of the creation tx
- deploy_bin: deploy contract by providing the contract bytecode only, this won't set any state variables
- get_code: get the bytecode of a given smart contract address
- get_codesize: get the length of the given bytes
- gen_creation: generate the simpllest deployment input bytecode, the same is using in deploy_bin
