
Description: Demonstrate the use of dynamic blocks to prevent the repetition of blocks within a resource

Use cases:
- avoid repeating block structures within a resource
- also allows for more dynamic (e.g. variable based) creation of block instances

Steps
- terraform init
- terraform apply # Observe that 5 VMs are created
                  # Note that the VMs have different port forwarding as described in var.vms["ports"]
- docker ps
- investigate the dynamic block code

```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                                              NAMES
941733dfffa9   3374313a7430   "/app/demo-binary -l…"   7 minutes ago   Up 7 minutes   0.0.0.0:8005->80/tcp, 0.0.0.0:8015->81/tcp, 0.0.0.0:8025->82/tcp   vm5
2e816cdd27de   3374313a7430   "/app/demo-binary -l…"   7 minutes ago   Up 7 minutes   0.0.0.0:8001->80/tcp, 0.0.0.0:8011->81/tcp, 0.0.0.0:8021->82/tcp   vm1
132cc358725c   3374313a7430   "/app/demo-binary -l…"   7 minutes ago   Up 7 minutes   0.0.0.0:8004->80/tcp, 0.0.0.0:8014->81/tcp, 0.0.0.0:8024->82/tcp   vm4
bdeeb66af78c   3374313a7430   "/app/demo-binary -l…"   7 minutes ago   Up 7 minutes   0.0.0.0:8002->80/tcp, 0.0.0.0:8012->81/tcp, 0.0.0.0:8022->82/tcp   vm2
2593c518148d   3374313a7430   "/app/demo-binary -l…"   7 minutes ago   Up 7 minutes   0.0.0.0:8003->80/tcp, 0.0.0.0:8013->81/tcp, 0.0.0.0:8023->82/tcp   vm3
```

- terraform destroy

Variations
- ...

