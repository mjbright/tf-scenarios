
variable container_details {
    type = map( map(string) )
    
    default = {
        "0" = {
          container_name = "test-foreach-1", 
          image          = 1,
          ipv4_port      = 80,
          ext_port       = 9090,
          },
        "1" = {
          container_name = "test-foreach-2",
          image          = 2
          ipv4_port      = 81,
          ext_port       = 9091,
          },
#        "2" = {
#          container_name = "test-foreach-3",
#          image          = 3,
#          ipv4_port      = 82,
#          ext_port       = 9092,
#          },
        "3" = {
          container_name = "test-foreach-4",
          image          = 4,
          ipv4_port      = 83,
          ext_port       = 9093,
          },
        "4" = {
          container_name = "test-foreach-5",
          image          = 5,
          ipv4_port      = 84,
          ext_port       = 9094,
          },
        "5" = {
          container_name = "test-foreach-6",
          image          = 6,
          ipv4_port      = 85,
          ext_port       = 9095,
          }
     }
}

