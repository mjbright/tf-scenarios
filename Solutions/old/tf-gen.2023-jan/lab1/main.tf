
resource "local_file" "test-file" {
  content  = "testing 'local_file' and 'random' providers: '${ random_string.test-string.result }' !"
  filename = "${path.root}/test.txt"
}

resource "random_string" "test-string" {
  length           = 8
  special          = false
}

output  "file_content"     { value = local_file.test-file.content }

