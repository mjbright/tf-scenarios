
# To get docker containerid:
#    docker ps --no-trunc

import {
    to = docker_container.legacy

    # NOTE: We must use the non-truncated "CONTAINER ID" seen above for the id field:
    #       NOT id = "test-container"
    #       NOT id = "f520d216b4c8"
    id = "f520d216b4c8a7a672848f0e2e11e18caf6d633736239fe0afc4d409a5f63a8d"
}
