
output container_info {
    value = join("\n",
       [ for idx, c in docker_container.test1.* :
           format("[%d] name:%s image:%s ip:%s",
              idx+1,
              c.name,
              docker_image.k8s-demo[idx].name,
              c.networks_advanced.*.ipv4_address[0] 
            )
        ]
    )   
}

