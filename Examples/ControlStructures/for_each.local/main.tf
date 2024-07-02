
variable opfiles {
    type    = list(string)
    default = [ "file1.txt", "file2.txt", "file3.txt", "file4.txt" ]
}

# Using local_file in-built Provider for light weight example
resource "local_file" "foo" {
    for_each  = toset(var.opfiles)

    # Note: key is same as value:
    content  = "File[${each.key}]: ${each.value}\n"
    filename = "${path.module}/files/${each.value}"
}

