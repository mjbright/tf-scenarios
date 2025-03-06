
# To get docker containerid:
#    docker ps --no-trunc

import {
    to = docker_container.legacy

    # NOTE: We must use the non-truncated "CONTAINER ID" seen above for the id field:
    #       NOT id = "test-container"
    #       NOT id = "f520d216b4c8"
    id = "6d449b8f90b6288cd77d44e0efc7009e495a56e86465176a49104be2a7df7903"
}
