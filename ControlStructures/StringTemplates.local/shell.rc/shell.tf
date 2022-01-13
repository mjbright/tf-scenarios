
locals {
  # NOTE: Use of $${VAR} in template to have ${VAR} in resulting shell script
  # Thanks to discussion here:
  # - https://stackoverflow.com/questions/66953938/escaping-dollar-sign-in-terraform

  shell_script = templatefile("${path.module}/templates/rcfile.tpl", {
    vars = {
      "NUM":     "10",
      "MESSAGE": "Hello world",
      "SLEEP":   "1"
  }}) 
}

output shell_script {
    value = local.shell_script
}


resource "local_file" "shell_script" {
    content         = local.shell_script
    filename        = "${path.module}/rcfile"
    file_permission = 0755
}

