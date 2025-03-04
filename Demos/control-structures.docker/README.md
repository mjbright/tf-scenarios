
# Control Structure Demos (using Docker Provider)

### 1.container

Initial simple single Docker container + image as a starting point

### 2.containers.count

Extended to create multiple containers from a single resource block
- using count

### 3.containers_images.count

Extended to create multiple containers & images from a single resource block (one for images, one for containers)
- using count

### 4.ternary

Demonstration of using the " ? : " ternary (if/then/else) operator
- setting an attribute value conditionally
- creating a resource conditionally (combined with use of count)

### 5.containers.for_each

Extended to create multiple containers & images from a single resource block (one for images, one for containers)
- using for_each

### 6.containers.for_in

Building up output values using the 'for in' construct

### 7.containers.string_template

Building up strings from a template
- used to create an output
- used to create a local string, then written to a local_file resource

### 8.containers.dynamic_block

Example of repeating a block within a resource (the "networks_advanced" attribute block of "docker_container" resources")

Use of for_each

