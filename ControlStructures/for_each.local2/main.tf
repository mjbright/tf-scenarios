
variable opfiles {
    type    = map(string)
    default = {
        "file1.txt": "File1 content",
        "file2.txt": "File2 content",
        "file3.txt": "File3 content",
        "file4.txt": "File4 content"
    }
}

# Using local_file in-built Provider for light weight example
resource "local_file" "foo" {
    for_each  = var.opfiles

    # Note: key is same as value:
    content  = "File[${each.key}]: ${each.value}\n"
    filename = "${path.module}/files/${each.key}"
}

