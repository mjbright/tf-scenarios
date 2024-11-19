


provider aws {
  region = "us-west-1"
}

resource aws_instance tf-example-import {
  count  = 3
  ami           = "ami-02a7ad1c45194c72f"
  instance_type = "t2.micro"

  provisioner local-exec {
      command = "echo ${ self.public_ip }  >> public_ips.txt"
  }
  provisioner local-exec {
      command = "echo ${ self.private_ip } >> private_ips.txt"
  }
}
  #i-0f2d4658a23fcd3bd
  #i-09eac1eeb11e4f47f
  #i-054d595026e619c67

	

