
These examples are very simple examples to demonstrate using terraform across mutliple environments

- 1.single-env: A module-based simple configuration to create a load-balancer in front of a set of backend servers [containers] for a single environment
- 2.multi-env:  The same approach extended to deploy the same configuration on multiple environments

# Modules

Both configs use
- the be-container-servers module to create the backend servers
- the fe-container-lb module to create the load-balancer and configure it to send traffic to the backend

```
modules/
├── be-container-servers
│   ├── containers.tf
│   ├── networks.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── variables.tf
└── fe-container-lb
    ├── containers.tf
    ├── haproxy.cfg.tf
    ├── provider.tf
    ├── templates
    │   └── haproxy.cfg.tpl
    └── variables.tf
```

# 1.single-env

This example is extremely simple comprising of 2 terraform config files.

The app.tf config calls out to the be-container-servers and fe-container-lb modules

Configuration files:

```
    ├── README.md
    ├── app.tf
    └── provider.tf
```

# 2.multi-env

This example implements the same configuration but replicated across 3 environments.

To do this
- we copy *all* configuration files into each of the env{1,2,3}/ folders
- we create a terraform.tfvars file in each folder with different parameters for each environment

Whilst this technique works, it is highly undesirable to have copies of the same configuration.

The use of modules for the actual resources reduces greatly the amount of duplication, nevertheless the root configs need to be duplicated here.

If we update a configuration it has to be copied to the other environments - there are significant risks of "configuration" drift.

Configuration files:
```
    ├── README.md
    ├── env1
    │   ├── app.tf
    │   ├── provider.tf
    │   ├── terraform.tfvars
    │   └── variables.tf
    ├── env2
    │   ├── app.tf
    │   ├── provider.tf
    │   ├── terraform.tfvars
    │   └── variables.tf
    └── env3
        ├── app.tf
        ├── provider.tf
        ├── terraform.tfvars
        └── variables.tf
```
                      
