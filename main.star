#  this is a workaround while we enable "--rpc.allow-unprotected-txs" in geth
#  the block time is also much faster on this branch
eth_network_package = import_module("github.com/kurtosis-tech/eth-network-package/main.star")
hardhat_module = import_module("github.com/kurtosis-tech/web3-tools/hardhat.star")
ephemery = import_module("github.com/kurtosis-tech/web3-tools/ephemery.star")
archway = import_module("github.com/kurtosis-tech/web3-tools/archway.star")

# This can be any prefunded acocunt here if you are running this against the eth-network-package
# https://github.com/kurtosis-tech/eth-network-package/blob/main/src/prelaunch_data_generator/genesis_constants/genesis_constants.star#L13
EPHEMERY_TESTING_PRIVATE_KEY = "ef5177cd0b6b21c87db5a0bf35d4084a8a57a9d6a064f86d51ac85f2b873a4e2"


def run(plan, args):

    archway.init(plan, "github.com/kurtosis-tech/web3-tools/wasms", "http://this-node-doesnt.exist")
    archway.store(plan, "wasms/foo.wasm")