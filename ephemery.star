NODE_ALPINE = "node:latest"
ROOT_DIR = "/tmp/ephemery"
EPHEMERY_PROJECT_DIR = ROOT_DIR + "/" + "ephemery-base-contracts"
EPHEMERY_SERVICE_NAME = "ephemery"
BASE_CONTRACTS = "https://github.com/pk910/ephemery-base-contracts.git"

# Creates an ephemery container with everything installed
def init(plan):
    plan.add_service(
        name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            image = NODE_ALPINE,
            entrypoint = ["sleep", "99999"]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["mkdir", ROOT_DIR]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cd {0} && git clone {1}".format(ROOT_DIR, BASE_CONTRACTS)]
        )
    )


    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cd {0} && npm install".format(EPHEMERY_PROJECT_DIR + "/deployer")]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cd {0} && npm run release".format(EPHEMERY_PROJECT_DIR + "/deployer")]
        )
    )


# private_key - the private key of the account that will be deploying smart contracts
# rpc_url - rpc url of the given node
# project_name - name of the project to deploy
def deploy(plan, private_key, rpc_url, project_name):
    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cd {0} && bin/deployer -p {1} -r {2} deploy {3}".format(EPHEMERY_PROJECT_DIR, private_key, rpc_url, project_name)]
        ),
    )

# cleans up the container
def destroy(plan):
    plan.remove_service(EPHEMERY_SERVICE_NAME)
