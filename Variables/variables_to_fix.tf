
variable t1 {
    type = X
    default = 111
}

variable t2 {
    type = X
    default = "111"
}

variable t3 {
    type = X
    default = true
}

variable t4 {
    type = X
    default = [ "1", "2", "3" ]
}

variable t5 {
    type = X
    default = [ 1, 2, 3 ]
}

variable t6 {
    type = X
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
    type = X
    default = 1000.0 * 10
}

variable t9 {
    type = X
    default = 10 / 10
}

variable t10 {
    type = X
    default = { "a": "hello", "b": { "a": "hello", "b": 1 }, "c": "bye" }
}

