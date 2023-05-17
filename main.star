eth_network_package = import_module("github.com/kurtosis-tech/eth-network-package/main.star")
hardhat_module = import_module("github.com/kurtosis-tech/web3-tools/hardhat.star")

def run(plan, args):
    participants, _ = eth_network_package.run(plan, args)
    el_client_rpc_ip_addr = participants[0].el_client_context.ip_addr
    el_client_rpc_port = participants[0].el_client_context.rpc_port_num
    rpc_url = "http://{0}:{1}".format(el_client_rpc_ip_addr, el_client_rpc_port)
    hardhat_env_vars = {
        "RPC_URI": rpc_url
    }

    hardhat_project = "github.com/kurtosis-tech/web3-tools/smart-contract-example"
    hardhat = hardhat_module.init(plan, hardhat_project, hardhat_env_vars)
    
    hardhat_module.task(plan, "balances", "localnet")
    hardhat_module.compile(plan)
    hardhat_module.run(plan, "scripts/deploy.ts", "localnet")
    hardhat_module.cleanup(plan)