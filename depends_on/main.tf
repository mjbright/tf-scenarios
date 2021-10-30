
resource "local_file" "foo" {
    content     = "foo!"
    filename = "${path.module}/files/test.txt"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/files/test.txt"
  output_path = "${path.module}/files/init.zip"

  depends_on = [ local_file.foo ]
}



