
variable encode_file {
    default = true
}

variable content {
    default = "Unencoded file content"
}

resource "local_file" "test_file" {
    content  = var.encode_file ? base64encode(var.content) : var.content
    filename = "${path.module}/files/test.txt"
}




