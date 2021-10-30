
variable list {
    default = [ "hello", "world", "from", "me" ]
}

variable map {
    default = {
        "key1": "value1",
        "another key2": "another value2",
        "yet another key3": "yet another value3",
    }
}

output list2list {
    value = [for s in var.list : upper(s)]
}

output map2list {
    value = [for k, v in var.map : length(k) + length(v)] 
}

output map2map {
    value = {for k,v in var.map : upper(k) => upper(v) }
}

output list2map {
    #value = {for s in var.list : substr(s, 0, 1) => s... if s != ""} 
    value = {for s in var.list : substr(s, 0, 1) => s }
}





