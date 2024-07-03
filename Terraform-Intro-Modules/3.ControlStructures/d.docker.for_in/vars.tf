
# This time we will define the VMs as a map:
variable vms {
    default = {
        "vm1": {
            "hostname": "vm1.local",
            "networks":  "bridge",
            "ext_port":  8001,
            "int_port":  80,
        },
        "vm2": {
            "hostname": "vm2.local",
            "networks":  "bridge",
            "ext_port":  8002,
            "int_port":  80,
        },
        "vm3": {
            "hostname": "vm3.local",
            "networks":  "bridge",
            "ext_port":  8003,
            "int_port":  80,
        },
        "vm4": {
            "hostname": "vm4.local",
            "networks":  "bridge",
            "ext_port":  8004,
            "int_port":  80,
        },
        "vm5": {
            "hostname": "vm5.local",
            #"networks":  "none",
            "networks":  "bridge",
            "ext_port":  8005,
            "int_port":  80,
        }
       }

    # But what happens if we decide to remove vm2 from the map ?
}

