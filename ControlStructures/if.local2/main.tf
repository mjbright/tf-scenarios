
variable content {
    default = "Unencoded file content"
}

variable write_file {
    #default = true
    default = false
}

# Note: write_file argument is used to determine if file exists or not:
resource "local_file" "test_file" {
    count    = var.write_file ? 1 : 0

    content  = var.content
    filename = "${path.module}/files/test.txt"
}




