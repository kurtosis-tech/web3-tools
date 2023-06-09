ARCHWAY = "archwaynetwork/archwayd"
ARCHWAY_DIR = "/tmp/archway/"
ARCHWAY_SERVICE = "archway"


# wasm - either a folder or a wasm file that will be uploaded to /tmp/archway
# node_rpc_url - the rpc url of the node
def init(plan, wasm_artifact_locator, node_rpc_url):
    wasm = plan.upload_files(wasm_artifact_locator)

    archway_service = plan.add_service(
        name = ARCHWAY_SERVICE,
        config = ServiceConfig(
            image = ARCHWAY,
            entrypoint = ["sleep", "999999"],
            files = {
                ARCHWAY_DIR : wasm
            },
            env_vars = {
                "RPC_URL": node_rpc_url,                
            }
        )
    )


def store(plan, contract):
    plan.exec(
        service_name = ARCHWAY_SERVICE,
        recipe = ExecRecipe(
            command = ["archwayd", "tx", "wasm", "store", "{0}{1}".format(ARCHWAY_DIR, contract), "--from", "mywallet", "--node", "$RPC_URL", "--chain-id", "constantine-3"]
        )
    )
    

