
# This variable will determine if we create the container or not:
#
variable container_create {
    default = true
}

# This variable will determine if the container name will be the var.default_name or a randomly generated string:
#
variable container_use_random_name {
    default = true
}

variable default_name {
    default = "ternary-container"
}

resource docker_image k8s-demo {
    name = "mjbright/k8s-demo:1"
}

# Create a random string of length 8 lower case characters iff var.container_use_random_name is true:
#
resource "random_string" "random" {
    count  = ( var.container_use_random_name ? 1 : 0 )

    length           = 8
    special          = false
    numeric          = false
    upper            = false
}

# Only create a single container - iff var.container_create is true:
#
resource docker_container test {
    # Use ternary operator:
    count = ( var.container_create ? 1 : 0 )

    image = docker_image.k8s-demo.image_id

    # Use ternary operator:
    name  = ( var.container_use_random_name ?  random_string.random[0].result : var.default_name )
}

