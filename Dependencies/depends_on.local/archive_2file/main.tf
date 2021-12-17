
resource "local_file" "file1" {
    content     = "File1 Contents !"
    filename = "${path.module}/files/test.txt"
}

resource "local_file" "file2" {
    content     = "File2 Contents !"
    filename = "${path.module}/files/test2.txt"
}

data "archive_file" "archive_2files" {
  type        = "zip"
  output_path = "${path.module}/files/2files.zip"
  excludes    = [ "${path.module}/2files.zip" ]

  source {
    source = local_file.file1
    #content  = "${data.template_file.vimrc.rendered}"
    #content     = "File1 Contents !"
    #filename = "${path.module}/files/test.txt"
    #filename = ".vimrc"
  }

  source {
    source = local_file.file2
    #source = local_file.file2
    #content  = "${data.template_file.ssh_config.rendered}"
    #filename = ".ssh/config"
  }

  #source {
    #content  = "${data.template_file.vimrc.rendered}"
    #filename = ".vimrc"
  #}

  #source {
    #content  = "${data.template_file.ssh_config.rendered}"
    #filename = ".ssh/config"
  #}

  # Depending only on file1:
  depends_on = [ local_file.file1 ]
  #depends_on = [ local_file.file1, local_file.file1 ]
}






