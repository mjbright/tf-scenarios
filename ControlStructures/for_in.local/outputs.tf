
variable list {
    default = [ "hello", "world", "" ]
}

variable map {
    default = {
        "key1":             "value1",
        "another key2":     "another value2",
        "yet another key3": "yet another value3",
    }
}

output input_list { value = var.list }
output input_map  { value = var.map  }

# Transformation:
output list2list {
    value = [for s in var.list : upper(s)]
}

# Transformation:
output map2list {
    value = [for k, v in var.map : length(k) + length(v)] 
}

# Transformation:
output map2map {
    value = {for k,v in var.map : upper(k) => upper(v) }
}

# Transformation:
output list2map {
    value = {for s in var.list : substr(s, 0, 1) => s }
}

# Transformation + filtering:
output list2map_filter {
    value = {for s in var.list : substr(s, 0, 1) => s if s != ""} 
}


# A faire: ellipsis / create tuple if repeated value in list 
#value = {for s in var.list : substr(s, 0, 1) => s... if s != ""} 


