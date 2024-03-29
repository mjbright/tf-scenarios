
variable opfiles {
    default = [ "file1.txt", "file2.txt", "file3.txt", "file4.txt" ]
}

# Using local_file in-built Provider for light weight example
resource "local_file" "foo" {
    count    = length(var.opfiles)

    content  = "Content for ${var.opfiles[ count.index ]}\n"
    filename = "${path.module}/files/${var.opfiles[ count.index ]}"
}

