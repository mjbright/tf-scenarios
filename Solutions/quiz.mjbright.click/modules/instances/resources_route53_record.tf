
resource "aws_route53_record" "my_name" {
   zone_id = var.zone_id
   name    = var.num_instances == 1 ?  "quiz.${var.domain}" : "quiz${count.index}.${var.domain}"
   count   = var.num_instances

   type    = "A"
   ttl     = "300"
   records = ["${element(aws_instance.example.*.public_ip, count.index)}"]
}

