# Web3-Tools

This repository contains tools in Starlark that we have seen people need in the Web3 community like hardhat and ephemery

The `main.star` in the repository is just a dummy `main.star` to show case the tools

### Run Instructions

```bash
kurtosis run github.com/kurtosis-tech/web3-tools
```

### Ephemery

You can use `ephemery.star` in your own Starlark Package as follows

```py
#  this is a workaround while we enable "--rpc.allow-unprotected-txs" in geth
#  the block time is also much faster on this branch
eth_network_package = import_module("github.com/kurtosis-tech/eth-network-package/main.star@high-but-low")
hardhat_module = import_module("github.com/kurtosis-tech/web3-tools/hardhat.star")
ephemery = import_module("github.com/kurtosis-tech/web3-tools/ephemery.star")

# This can be any prefunded acocunt here if you are running this against the eth-network-package
# https://github.com/kurtosis-tech/eth-network-package/blob/main/src/prelaunch_data_generator/genesis_constants/genesis_constants.star#L13
EPHEMERY_TESTING_PRIVATE_KEY = "ef5177cd0b6b21c87db5a0bf35d4084a8a57a9d6a064f86d51ac85f2b873a4e2"

def run(plan, args):
    participants, _ = eth_network_package.run(plan, args)
    el_client_rpc_ip_addr = participants[0].el_client_context.ip_addr
    el_client_rpc_port = participants[0].el_client_context.rpc_port_num
    rpc_url = "http://{0}:{1}".format(el_client_rpc_ip_addr, el_client_rpc_port)

    run_ephemery_example(plan, rpc_url)


def run_ephemery_example(plan, rpc_url):
    ephemery.init(plan)
    ephemery.deploy(plan, EPHEMERY_TESTING_PRIVATE_KEY, rpc_url, "_manager")
```

### Hardhat

You can use `hardhat.star` in  your own Starlark package as follows:

```py
eth_network_package = import_module("github.com/kurtosis-tech/eth-network-package/main.star")
# this import works from any Kurtosis pacakge or script anywhere
hardhat_module = import_module("github.com/kurtosis-tech/web3-tools/hardhat.star")

def run(plan, args):
    # Etheruem network setup
    participants, _ = eth_network_package.run(plan, args)
    el_client_rpc_ip_addr = participants[0].el_client_context.ip_addr
    el_client_rpc_port = participants[0].el_client_context.rpc_port_num
    rpc_url = "http://{0}:{1}".format(el_client_rpc_ip_addr, el_client_rpc_port)

    # we pass the rpc URL of any of the ethereum nodes inside Docker as environment variables
    # look at smart-contract-example/hardhat.config.ts to see how the variable is read and passed further
    hardhat_env_vars = {
        "RPC_URI": rpc_url
    }
    # this can be any folder containing the hardhat.config.ts and other hardhat files
    # this has to be a part of a Kurtosis package (needs a kurtosis.yml) at root
    hardhat_project = "github.com/kurtosis-tech/web3-tools/smart-contract-example"

    # we initialize the hardhat module passing the hardhat_project & hardhat_env_vars
    # the hardhat_env_vars argument is optional and defaults to None
    hardhat = hardhat_module.init(plan, hardhat_project, hardhat_env_vars)
    
    # we run the `balances` task in the hardhat.config.ts; note that the default network is `local`
    # we override it to localnet here
    hardhat_module.task(plan, "balances", "localnet")

    # this runs npx hardhat compile in the hardhat_project mentioned above
    hardhat_module.compile(plan)

    # this runs npx hardhat run scripts/deploy.ts --network localnet
    # note that the "localnet" is optional; if it wasn't passed it would have defaulted to local
    hardhat_module.run(plan, "scripts/deploy.ts", "localnet")

    # this runs npx hardhat test test/chiptoken.js --network localnet
    # note that the "localnet" is optional; if it wasn't passed it would have defaulted to local
    hardhat_module.run(plan, "test/chiptoken.js", "localnet")
    
    # this just removes the started container
    hardhat_module.cleanup(plan)
```

### Examples

We recommend you look at the most recent CI run on main to see the above examples in `main.star` in action
