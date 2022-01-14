
An example combining several features which we've seen.
- Modules, and combining several related resource creations within the same instances module
  - Creation of tls private key, aws_key_pair, local_file (of the private .pem key)
  - Creation of aws_instance resource with security group with ingress/egress rule dymamic blocks
  - output definitions using "for in" expressions to build up sample commands to access the created resources
  - Passing of arguments such as a user_data.sh script to provision the resource using cloud-init
  - Use of random_id resource to provide a random element to resource names (security_group and aws_key_pair)
  - Use of data source to obtain the latest Ubuntu 20.04 LTS image
    - use of  lifecycle/ignore_change to prevent auto-recreation of aws_instance each time a new image is available
- Use of local-exec, remote-exec, file and user_data provisioners
- Use of templating (for webserver.sh.tpl)

+ This example also includes the creation of Route53 (AWS DNS) records for the created instance(s)

Note: Currently this repo does not include
- the mjbright.click domain zone_id - you must provide your own Route53 controlled domain
- the quiz application
  - the app is available at https://github.com/mjbright/quiz but lacks the quiz content
  - example quiz content will be provided ....


