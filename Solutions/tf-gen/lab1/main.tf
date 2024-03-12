variable test {
    description =   "It is good practice to add a description"
    default     =   "a test value"
}

output op_test  { value = var.test }
output op_test2 { value = "The same variable '${var.test}' using string interpolation" } 

