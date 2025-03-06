
moved {
    from=docker_network.app_network
    to=module.mod_call.docker_network.app_network
}

moved {
    from=docker_container.server["container1"]
    to=module.mod_call.docker_container.server["container1"]
}

moved {
    from=docker_container.server["container2"]
    to=module.mod_call.docker_container.server["container2"]
}

moved {
    from=docker_container.server["container3"]
    to=module.mod_call.docker_container.server["container3"]
}

moved {
    from=docker_container.server["container4"]
    to=module.mod_call.docker_container.server["container4"]
}

moved {
    from=docker_image.image["container1"]
    to=module.mod_call.docker_image.image["container1"]
}

moved {
    from=docker_image.image["container2"]
    to=module.mod_call.docker_image.image["container2"]
}

moved {
    from=docker_image.image["container3"]
    to=module.mod_call.docker_image.image["container3"]
}

moved {
    from=docker_image.image["container4"]
    to=module.mod_call.docker_image.image["container4"]
}




