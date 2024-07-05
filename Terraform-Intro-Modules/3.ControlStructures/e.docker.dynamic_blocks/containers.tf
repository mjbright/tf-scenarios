
# Humour me - of course these are VMs ...
#

# In this example, we will avoid creating 3 "ports" blocks within the "docker_container" resource
# through the use of the "dynamic blocks" mechanism
#
# We will use the "dynamic blocks" mechanism to create multiple "ports" blocks in the resource
# by "looping" over the "ports" element of each "vm" entry in var.vms !
#
# This adds some complexity into the "resource.docker_container.test" code but prevents repeating the "ports" block
#
# This is maybe uninteresting for just 3 port mappings per VM but imagine if we had 30 port mappings per VM
#
variable vms {
    default = {
        "vm1": {
            "hostname": "vm1.local",
            "networks":  "bridge",
            "ports": {
               "80": 8001
               "81": 8011
               "82": 8021
            },
        },
        "vm2": {
            "hostname": "vm2.local",
            "networks":  "bridge",
            "ports": {
               "80": 8002
               "81": 8012
               "82": 8022
            },
        },
        "vm3": {
            "hostname": "vm3.local",
            "networks":  "bridge",
            "ports": {
               "80": 8003
               "81": 8013
               "82": 8023
            },
        },
        "vm4": {
            "hostname": "vm4.local",
            "networks":  "bridge",
            "ports": {
               "80": 8004
               "81": 8014
               "82": 8024
            },
        },
        "vm5": {
            "hostname": "vm5.local",
            "networks":  "bridge",
            "ports": {
               "80": 8005
               "81": 8015
               "82": 8025
            },
        }
    }
}

resource docker_image k8s-demo {
  name = "mjbright/k8s-demo:1"
  force_remove = false
}

resource docker_container test {
    for_each = var.vms

    image = docker_image.k8s-demo.image_id

    name     = each.key
    hostname = each.value["hostname"]
    networks_advanced {
        name = each.value["networks"]
    }

    # dynamic block definition:
    dynamic ports {
        # Here each.value refers to the value for the var.vms entry:
        for_each = each.value.ports

        content {
            internal = ports.key
            external = ports.value
        }
    }
}

