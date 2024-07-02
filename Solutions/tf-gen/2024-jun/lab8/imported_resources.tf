# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "8878e19af1edee435fa05c225ff5dfa614f814db5cd02c5aa6e30dfda660e5f3"
resource "docker_container" "myimport" {
  attach                                      = null
  cgroupns_mode                               = null
  command                                     = ["/app/demo-binary", "-l", "80", "-L", "0", "-R", "0"]
  container_read_refresh_timeout_milliseconds = null
  cpu_set                                     = null
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
  hostname                                    = "8878e19af1ed"
  image                                       = "sha256:c6bb37f7e86b749a53e59ca0fa246b2dc4fe1c2efd9ee7429a1fa85c7bd3685e"
  init                                        = false
  ipc_mode                                    = "private"
  log_driver                                  = "json-file"
  log_opts                                    = {}
  logs                                        = null
  max_retry_count                             = 0
  memory                                      = 0
  memory_swap                                 = 0
  must_run                                    = null
  name                                        = "test-container"
  network_mode                                = "default"
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
    external = 8080
    internal = 80
    ip       = "::"
    protocol = "tcp"
  }
  ports {
    external = 8080
    internal = 80
    ip       = "::"
    protocol = "tcp"
  }
}
