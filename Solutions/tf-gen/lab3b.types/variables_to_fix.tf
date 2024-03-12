
variable t1 {
    type = number
    default = 111
}

variable t2 {
    type = string
    default = "111"
}

variable t3 {
    type = string
    default = true
}

variable t4 {
    type = list(string)
    default = [ "1", "2", "3" ]
}

variable t5 {
    type = list(number)
    default = [ 1, 2, 3 ]
}

variable t6 {
    type = list(bool)
    default = [ true, false, true ]
}

variable t7 {
    type = map(string)
    default = { "a": 1, "b": true, "c": "3" }
}

variable t7b {
    type = map(any)
    default = { "a": 21, "b": true, "c": "23" }
}

variable t8 {
    type = number
    default = 1000.0 * 10
}

variable t9 {
    type = number
    default = 10 / 10
}


