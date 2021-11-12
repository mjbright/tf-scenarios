
resource "local_file" "file1" {
    content     = "File1 contents !"
    filename = "${path.module}/files/test.txt"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = local_file.file1.filename
  output_path = "${path.module}/files/init.zip"

  depends_on = [ local_file.file1 ]
}



