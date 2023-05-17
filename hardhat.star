# HardHat has problems with node 20
NODE_ALPINE = "node:14.21.3-alpine"
HARDHAT_PROJECT_DIR = "/tmp/hardhat/"
HARDHAT_SERVICE_NAME = "hardhat"

def init(plan, hardhat_project_url, env_vars = None):
    harhdat_project = plan.upload_files(hardhat_project_url)

    hardhat_service = plan.add_service(
        name = "hardhat",
        config = ServiceConfig(
            image = NODE_ALPINE,
            entrypoint = ["sleep", "999999"],
            files = {
                HARDHAT_PROJECT_DIR : harhdat_project
            },
            env_vars = env_vars,
        )
    )

    plan.exec(
        service_name = HARDHAT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cd {0} && npm install".format(HARDHAT_PROJECT_DIR)]
        )
    )

    return hardhat_service


def test(plan, smart_contract, network = "local"):
    command_arr = ["cd", HARDHAT_PROJECT_DIR, "&&", "npx", "hardhat", "test", smart_contract, "--network", network]
    return plan.exec(
        service_name = HARDHAT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", " ".join(command_arr)]
        )
    )


# runs npx hardhat compile with the given smart contract
def compile(plan):
    command_arr = ["cd", HARDHAT_PROJECT_DIR, "&&", "npx", "hardhat", "compile"]
    return plan.exec(
        service_name = HARDHAT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", " ".join(command_arr)]
        )
    )


# runs npx hardhat run with the given contract
def run(plan, smart_contract, network = "local"):
    command_arr = ["cd", HARDHAT_PROJECT_DIR, "&&", "npx", "hardhat", "run", smart_contract, "--network", network]
    return plan.exec(
        service_name = HARDHAT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", " ".join(command_arr)]
        )
    )


def task(plan, task_name, network = "local"):
    command_arr = ["cd", HARDHAT_PROJECT_DIR, "&&", "npx", "hardhat", task_name, "--network", network]
    return plan.exec(
        service_name = HARDHAT_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", " ".join(command_arr)]
        )
    )


def cleanup(plan):
    plan.remove_service(HARDHAT_SERVICE_NAME)
