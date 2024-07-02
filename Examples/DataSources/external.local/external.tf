
# External data sources call out to some external program
# Note: The program must output valid JSON

data "external" "list-files" {
  program = [
    "python3", "opjson.py"
  ]
}

output "external_source" {
  value = data.external.list-files.result
}

output "external_source_hello" {
  value = data.external.list-files.result.hello
}
