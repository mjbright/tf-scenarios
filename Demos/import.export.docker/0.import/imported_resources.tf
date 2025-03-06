# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "6d449b8f90b6288cd77d44e0efc7009e495a56e86465176a49104be2a7df7903"
resource "docker_container" "legacy" {
  attach                                      = null
  cgroupns_mode                               = null
  command                                     = ["/app/demo-binary", "-l", "80", "-L", "0", "-R", "0"]
  container_read_refresh_timeout_milliseconds = null
  cpu_set = 1
  cpu_shares                                  = 0
  destroy_grace_seconds                       = null
  dns                                         = []
  dns_opts                                    = []
  dns_search                                  = []
  domainname                                  = null
  entrypoint                                  = []
  env = []
  gpus                                        = null
  group_add                                   = []
  hostname                                    = "6d449b8f90b6"
  image                                       = "sha256:011b202f7c5d62f267a042d4bb41583bd640f512184bf8114cc5e564fec42c33"
  init                                        = false
  ipc_mode                                    = "private"
  log_driver                                  = "json-file"
  log_opts                                    = {}
  logs                                        = null
  max_retry_count                             = 0
  memory                                      = 0
  memory_swap                                 = 0
  must_run                                    = null
  name                                        = "legacy_container"
  network_mode                                = "bridge"
  pid_mode                                    = null
  privileged                                  = false
  publish_all_ports                           = false
  read_only                                   = false
  remove_volumes                              = null
  restart                                     = "no"
  rm                                          = false
  runtime                                     = "runc"
  security_opts                               = []
  shm_size                                    = 64
  start                                       = null
  stdin_open                                  = false
  stop_signal                                 = null
  stop_timeout                                = 0
  storage_opts                                = {}
  sysctls                                     = {}
  tmpfs                                       = {}
  tty                                         = false
  user                                        = null
  userns_mode                                 = null
  wait                                        = null
  wait_timeout                                = null
  working_dir                                 = "/app"
  ports {
    external = 6000
    internal = 80
    ip       = "::"
    protocol = "tcp"
  }
  ports {
    external = 6000
    internal = 80
    ip       = "::"
    protocol = "tcp"
  }
}
