
output ALL_resources {
  value = join("\n", [
    for r in data.azurerm_resources.all-in-group.resources : format("%s: %s [%v]", r.type, r.name, r.tags)
    ])
}

output VM_resources {
  value = join("\n", [
    for r in data.azurerm_resources.vms-in-group.resources : format("%s [%v]", r.name, r.tags)
    ])
}

