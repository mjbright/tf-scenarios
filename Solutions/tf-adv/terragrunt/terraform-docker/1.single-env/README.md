
Simple application comprising of containerized:
- Front-end haproxy load-balancer
- Back-end multiple servers

Front-end and Back-end components are provided through modules
- modules/be-container-servers
- modules/fe-container-lb

The root configuration is in app.tf which makes 2 module calls:
- module be-servers { source          = "./modules/be-container-servers" ... }
- module fe-lb      { source          = "./modules/fe-container-lb"      ... }

The module call fe-lb picks up the server ip address from the be-servers module call
and uses this information to create a haproxy.cfg to configure the load-balancer correctly.

The haproxy dashboard is exposed on port 9999

