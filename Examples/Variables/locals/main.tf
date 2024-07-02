
#provider "aws" { region = "us-west-1" }

locals {
    info_val    = "just some unimport values"

    size = 10
    area = local.size * 3.1415926835 * local.size
}

output test_local {
    value = local.info_val
}

output area_cercle {
    value = local.area 
}

output op_area_cercle {
    value = "area approx=${floor(local.area)} cm^2"
}

