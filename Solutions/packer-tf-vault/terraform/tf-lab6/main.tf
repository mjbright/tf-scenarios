


provider aws {
  region = "us-west-1"
}

resource aws_instance tf-example-import {
  count  = 3
  ami          = "i-0f2d4658a23fcd3bd"
  instance_type = "t2.micro"
}
  #i-0f2d4658a23fcd3bd
  #i-09eac1eeb11e4f47f
  #i-054d595026e619c67

	

