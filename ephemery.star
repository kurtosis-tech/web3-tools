NODE_ALPINE = "node:alpine"
ROOT_DIR = "/tmp/ephemery"
EPHEMERY_PROJECT_DIR = ROOT_DIR + "/" + "ephemery-base-contracts"
EPHEMERY_SERVICE_NAME = "ephemery"
BASE_CONTRACTS = "https://github.com/pk910/ephemery-base-contracts.git"

def init(plan):
    plan.add_service(
        service_name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            entrypoint = ["sleep", "99999"]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            command = ["mkdir", ROOT_DIR]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            command = ["/bin/sh", "-c", "cd {0} && git clone {1}".format(ROOT_DIR, BASE_CONTRACTS)]
        )
    )


    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            command = ["/bin/sh", "-c", "cd {0} && npm install".format(EPHEMERY_PROJECT_DIR + "/deployer")]
        )
    )

    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        config = ServiceConfig(
            command = ["/bin/sh", "-c", "cd {0} && npm run release".format(EPHEMERY_PROJECT_DIR + "/deployer")]
        )
    )


def deploy(private_key, rpc_url, project_name):
    plan.exec(
        service_name = EPHEMERY_SERVICE_NAME,
        command = ["/bin/sh", "-c", "cd {0} && bin/deployer -p {1} -r {2} deploy {3}".format(EPHEMERY_PROJECT_DIR, private_key, rpc_url, [project_name])]
    )


def destroy():
    plan.remove_service(EPHEMERY_SERVICE_NAME)



