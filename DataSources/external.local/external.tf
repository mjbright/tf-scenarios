data "external" "list-files" {
  program = [
    "python3", "opjson.py"
  ]
}

output "external_source" {
  value = data.external.list-files.result
}

