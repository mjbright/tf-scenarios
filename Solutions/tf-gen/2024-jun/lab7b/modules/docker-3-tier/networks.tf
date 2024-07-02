
locals {
    # Create list of all defined networks (distinct(): removes duplicates)
    networks = distinct(
       concat( var.tier1["networks"], var.tier2["networks"], var.tier3["networks"] )
    )
}

resource docker_network tiers {
    count = length(local.networks)

    name   = local.networks[ count.index ]
    driver = "bridge"
}

output networks {
    value = local.networks
}


