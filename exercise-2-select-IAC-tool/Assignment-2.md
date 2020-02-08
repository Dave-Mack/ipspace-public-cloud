# Networking in Public Cloud Deployments Exercise 2
***

## Assignment 
Select a public cloud provider you'd like to work with, create your public cloud account, 
select an IaC tool of your choice, and create some simple public cloud infrastructure with
that tool.

I selected to use Terraform with AWS to create a VPC and subnet within that VPC. I then
created an EC2 instance in my subnet. I modified my Terraform file to change the CIDR for 
the VPC and subnet and created the infrastructure again.

## Initial Terraform file

```
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "basic" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "basic_subnet" {
  vpc_id = aws_vpc.basic.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "simple" {
  ami = "ami-40d28157"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.basic_subnet.id
}
```

### Terraform Apply

```exercise2$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.simple will be created
  + resource "aws_instance" "simple" {
      + ami                          = "ami-40d28157"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_subnet.basic_subnet will be created
  + resource "aws_subnet" "basic_subnet" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = (known after apply)
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.1.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block                 = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.basic will be created
  + resource "aws_vpc" "basic" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.basic: Creating...
aws_vpc.basic: Creation complete after 1s [id=vpc-005c91122308a957f]
aws_subnet.basic_subnet: Creating...
aws_subnet.basic_subnet: Creation complete after 1s [id=subnet-09f1c1fbba8190428]
aws_instance.simple: Creating...
aws_instance.simple: Still creating... [10s elapsed]
aws_instance.simple: Still creating... [20s elapsed]
aws_instance.simple: Still creating... [30s elapsed]
aws_instance.simple: Creation complete after 32s [id=i-0a1db44053c207c2c]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

### Terrraform show

```
exercise2$ terraform show
# aws_instance.simple:
resource "aws_instance" "simple" {
    ami                          = "ami-40d28157"
    arn                          = "arn:aws:ec2:us-east-1:396946667626:instance/i-0a1db44053c207c2c"
    associate_public_ip_address  = false
    availability_zone            = "us-east-1a"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    id                           = "i-0a1db44053c207c2c"
    instance_state               = "running"
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    primary_network_interface_id = "eni-0dc94e9dccc696ae4"
    private_dns                  = "ip-10-0-1-217.ec2.internal"
    private_ip                   = "10.0.1.217"
    security_groups              = []
    source_dest_check            = true
    subnet_id                    = "subnet-09f1c1fbba8190428"
    tenancy                      = "default"
    volume_tags                  = {}
    vpc_security_group_ids       = [
        "sg-0511e687272e97781",
    ]

    credit_specification {
        cpu_credits = "standard"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        volume_id             = "vol-091270f0ec366d3c9"
        volume_size           = 8
        volume_type           = "gp2"
    }
}

# aws_subnet.basic_subnet:
resource "aws_subnet" "basic_subnet" {
    arn                             = "arn:aws:ec2:us-east-1:396946667626:subnet/subnet-09f1c1fbba8190428"
    assign_ipv6_address_on_creation = false
    availability_zone               = "us-east-1a"
    availability_zone_id            = "use1-az4"
    cidr_block                      = "10.0.1.0/24"
    id                              = "subnet-09f1c1fbba8190428"
    map_public_ip_on_launch         = false
    owner_id                        = "396946667626"
    vpc_id                          = "vpc-005c91122308a957f"
}

# aws_vpc.basic:
resource "aws_vpc" "basic" {
    arn                              = "arn:aws:ec2:us-east-1:396946667626:vpc/vpc-005c91122308a957f"
    assign_generated_ipv6_cidr_block = false
    cidr_block                       = "10.0.0.0/16"
    default_network_acl_id           = "acl-033a4d6e7421b3b19"
    default_route_table_id           = "rtb-05a5ea1cd0953b4ec"
    default_security_group_id        = "sg-0511e687272e97781"
    dhcp_options_id                  = "dopt-5aef883d"
    enable_classiclink               = false
    enable_classiclink_dns_support   = false
    enable_dns_hostnames             = false
    enable_dns_support               = true
    id                               = "vpc-005c91122308a957f"
    instance_tenancy                 = "default"
    main_route_table_id              = "rtb-05a5ea1cd0953b4ec"
    owner_id                         = "396946667626"
}
```

### Terraform destroy 

```
exercise2$ terraform destroy
aws_vpc.basic: Refreshing state... [id=vpc-005c91122308a957f]
aws_subnet.basic_subnet: Refreshing state... [id=subnet-09f1c1fbba8190428]
aws_instance.simple: Refreshing state... [id=i-0a1db44053c207c2c]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.simple will be destroyed
  - resource "aws_instance" "simple" {
      - ami                          = "ami-40d28157" -> null
      - arn                          = "arn:aws:ec2:us-east-1:396946667626:instance/i-0a1db44053c207c2c" -> null
      - associate_public_ip_address  = false -> null
      - availability_zone            = "us-east-1a" -> null
      - cpu_core_count               = 1 -> null
      - cpu_threads_per_core         = 1 -> null
      - disable_api_termination      = false -> null
      - ebs_optimized                = false -> null
      - get_password_data            = false -> null
      - id                           = "i-0a1db44053c207c2c" -> null
      - instance_state               = "running" -> null
      - instance_type                = "t2.micro" -> null
      - ipv6_address_count           = 0 -> null
      - ipv6_addresses               = [] -> null
      - monitoring                   = false -> null
      - primary_network_interface_id = "eni-0dc94e9dccc696ae4" -> null
      - private_dns                  = "ip-10-0-1-217.ec2.internal" -> null
      - private_ip                   = "10.0.1.217" -> null
      - security_groups              = [] -> null
      - source_dest_check            = true -> null
      - subnet_id                    = "subnet-09f1c1fbba8190428" -> null
      - tags                         = {} -> null
      - tenancy                      = "default" -> null
      - volume_tags                  = {} -> null
      - vpc_security_group_ids       = [
          - "sg-0511e687272e97781",
        ] -> null

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - volume_id             = "vol-091270f0ec366d3c9" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_subnet.basic_subnet will be destroyed
  - resource "aws_subnet" "basic_subnet" {
      - arn                             = "arn:aws:ec2:us-east-1:396946667626:subnet/subnet-09f1c1fbba8190428" -> null
      - assign_ipv6_address_on_creation = false -> null
      - availability_zone               = "us-east-1a" -> null
      - availability_zone_id            = "use1-az4" -> null
      - cidr_block                      = "10.0.1.0/24" -> null
      - id                              = "subnet-09f1c1fbba8190428" -> null
      - map_public_ip_on_launch         = false -> null
      - owner_id                        = "396946667626" -> null
      - tags                            = {} -> null
      - vpc_id                          = "vpc-005c91122308a957f" -> null
    }

  # aws_vpc.basic will be destroyed
  - resource "aws_vpc" "basic" {
      - arn                              = "arn:aws:ec2:us-east-1:396946667626:vpc/vpc-005c91122308a957f" -> null
      - assign_generated_ipv6_cidr_block = false -> null
      - cidr_block                       = "10.0.0.0/16" -> null
      - default_network_acl_id           = "acl-033a4d6e7421b3b19" -> null
      - default_route_table_id           = "rtb-05a5ea1cd0953b4ec" -> null
      - default_security_group_id        = "sg-0511e687272e97781" -> null
      - dhcp_options_id                  = "dopt-5aef883d" -> null
      - enable_classiclink               = false -> null
      - enable_classiclink_dns_support   = false -> null
      - enable_dns_hostnames             = false -> null
      - enable_dns_support               = true -> null
      - id                               = "vpc-005c91122308a957f" -> null
      - instance_tenancy                 = "default" -> null
      - main_route_table_id              = "rtb-05a5ea1cd0953b4ec" -> null
      - owner_id                         = "396946667626" -> null
      - tags                             = {} -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.simple: Destroying... [id=i-0a1db44053c207c2c]
aws_instance.simple: Still destroying... [id=i-0a1db44053c207c2c, 10s elapsed]
aws_instance.simple: Still destroying... [id=i-0a1db44053c207c2c, 20s elapsed]
aws_instance.simple: Destruction complete after 30s
aws_subnet.basic_subnet: Destroying... [id=subnet-09f1c1fbba8190428]
aws_subnet.basic_subnet: Destruction complete after 1s
aws_vpc.basic: Destroying... [id=vpc-005c91122308a957f]
aws_vpc.basic: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```

## Modified Terrafrom file with new CIDR blocks


```
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "basic" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "basic_subnet" {
  vpc_id = aws_vpc.basic.id
  cidr_block = "172.16.1.0/24"
}

resource "aws_instance" "simple" {
  ami = "ami-40d28157"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.basic_subnet.id
}
```

### Terraform apply

```
exercise2$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.simple will be created
  + resource "aws_instance" "simple" {
      + ami                          = "ami-40d28157"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_subnet.basic_subnet will be created
  + resource "aws_subnet" "basic_subnet" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = (known after apply)
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "172.16.1.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block                 = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.basic will be created
  + resource "aws_vpc" "basic" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "172.16.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.basic: Creating...
aws_vpc.basic: Creation complete after 2s [id=vpc-09299e894452e73e8]
aws_subnet.basic_subnet: Creating...
aws_subnet.basic_subnet: Creation complete after 0s [id=subnet-0b39330072032211d]
aws_instance.simple: Creating...
aws_instance.simple: Still creating... [10s elapsed]
aws_instance.simple: Still creating... [20s elapsed]
aws_instance.simple: Still creating... [30s elapsed]
aws_instance.simple: Creation complete after 33s [id=i-0009d7ff9db0ca6da]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

### Terraform show demonstrating new CIDR blocks in use.
```

```
exercise2$ terraform show
# aws_instance.simple:
resource "aws_instance" "simple" {
    ami                          = "ami-40d28157"
    arn                          = "arn:aws:ec2:us-east-1:396946667626:instance/i-0009d7ff9db0ca6da"
    associate_public_ip_address  = false
    availability_zone            = "us-east-1a"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    id                           = "i-0009d7ff9db0ca6da"
    instance_state               = "running"
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    primary_network_interface_id = "eni-097d4001d8fef3042"
    private_dns                  = "ip-172-16-1-219.ec2.internal"
    private_ip                   = **"172.16.1.219"**
    security_groups              = []
    source_dest_check            = true
    subnet_id                    = "subnet-0b39330072032211d"
    tenancy                      = "default"
    volume_tags                  = {}
    vpc_security_group_ids       = [
        "sg-06702e16e5413a607",
    ]

    credit_specification {
        cpu_credits = "standard"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        volume_id             = "vol-0c1604f5234de5ca3"
        volume_size           = 8
        volume_type           = "gp2"
    }
}

# aws_subnet.basic_subnet:
resource "aws_subnet" "basic_subnet" {
    arn                             = "arn:aws:ec2:us-east-1:396946667626:subnet/subnet-0b39330072032211d"
    assign_ipv6_address_on_creation = false
    availability_zone               = "us-east-1a"
    availability_zone_id            = "use1-az4"
    cidr_block                      = **"172.16.1.0/24"**
    id                              = "subnet-0b39330072032211d"
    map_public_ip_on_launch         = false
    owner_id                        = "396946667626"
    vpc_id                          = "vpc-09299e894452e73e8"
}

# aws_vpc.basic:
resource "aws_vpc" "basic" {
    arn                              = "arn:aws:ec2:us-east-1:396946667626:vpc/vpc-09299e894452e73e8"
    assign_generated_ipv6_cidr_block = false
    cidr_block                       = **"172.16.0.0/16"**
    default_network_acl_id           = "acl-05363ecde4704a7c9"
    default_route_table_id           = "rtb-08d1c2d282a7e15fe"
    default_security_group_id        = "sg-06702e16e5413a607"
    dhcp_options_id                  = "dopt-5aef883d"
    enable_classiclink               = false
    enable_classiclink_dns_support   = false
    enable_dns_hostnames             = false
    enable_dns_support               = true
    id                               = "vpc-09299e894452e73e8"
    instance_tenancy                 = "default"
    main_route_table_id              = "rtb-08d1c2d282a7e15fe"
    owner_id                         = "396946667626"
}
```

### Terraform destroy

```
exercise2$ terraform destroy
aws_vpc.basic: Refreshing state... [id=vpc-09299e894452e73e8]
aws_subnet.basic_subnet: Refreshing state... [id=subnet-0b39330072032211d]
aws_instance.simple: Refreshing state... [id=i-0009d7ff9db0ca6da]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.simple will be destroyed
  - resource "aws_instance" "simple" {
      - ami                          = "ami-40d28157" -> null
      - arn                          = "arn:aws:ec2:us-east-1:396946667626:instance/i-0009d7ff9db0ca6da" -> null
      - associate_public_ip_address  = false -> null
      - availability_zone            = "us-east-1a" -> null
      - cpu_core_count               = 1 -> null
      - cpu_threads_per_core         = 1 -> null
      - disable_api_termination      = false -> null
      - ebs_optimized                = false -> null
      - get_password_data            = false -> null
      - id                           = "i-0009d7ff9db0ca6da" -> null
      - instance_state               = "running" -> null
      - instance_type                = "t2.micro" -> null
      - ipv6_address_count           = 0 -> null
      - ipv6_addresses               = [] -> null
      - monitoring                   = false -> null
      - primary_network_interface_id = "eni-097d4001d8fef3042" -> null
      - private_dns                  = "ip-172-16-1-219.ec2.internal" -> null
      - private_ip                   = "172.16.1.219" -> null
      - security_groups              = [] -> null
      - source_dest_check            = true -> null
      - subnet_id                    = "subnet-0b39330072032211d" -> null
      - tags                         = {} -> null
      - tenancy                      = "default" -> null
      - volume_tags                  = {} -> null
      - vpc_security_group_ids       = [
          - "sg-06702e16e5413a607",
        ] -> null

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - volume_id             = "vol-0c1604f5234de5ca3" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_subnet.basic_subnet will be destroyed
  - resource "aws_subnet" "basic_subnet" {
      - arn                             = "arn:aws:ec2:us-east-1:396946667626:subnet/subnet-0b39330072032211d" -> null
      - assign_ipv6_address_on_creation = false -> null
      - availability_zone               = "us-east-1a" -> null
      - availability_zone_id            = "use1-az4" -> null
      - cidr_block                      = "172.16.1.0/24" -> null
      - id                              = "subnet-0b39330072032211d" -> null
      - map_public_ip_on_launch         = false -> null
      - owner_id                        = "396946667626" -> null
      - tags                            = {} -> null
      - vpc_id                          = "vpc-09299e894452e73e8" -> null
    }

  # aws_vpc.basic will be destroyed
  - resource "aws_vpc" "basic" {
      - arn                              = "arn:aws:ec2:us-east-1:396946667626:vpc/vpc-09299e894452e73e8" -> null
      - assign_generated_ipv6_cidr_block = false -> null
      - cidr_block                       = "172.16.0.0/16" -> null
      - default_network_acl_id           = "acl-05363ecde4704a7c9" -> null
      - default_route_table_id           = "rtb-08d1c2d282a7e15fe" -> null
      - default_security_group_id        = "sg-06702e16e5413a607" -> null
      - dhcp_options_id                  = "dopt-5aef883d" -> null
      - enable_classiclink               = false -> null
      - enable_classiclink_dns_support   = false -> null
      - enable_dns_hostnames             = false -> null
      - enable_dns_support               = true -> null
      - id                               = "vpc-09299e894452e73e8" -> null
      - instance_tenancy                 = "default" -> null
      - main_route_table_id              = "rtb-08d1c2d282a7e15fe" -> null
      - owner_id                         = "396946667626" -> null
      - tags                             = {} -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.simple: Destroying... [id=i-0009d7ff9db0ca6da]
aws_instance.simple: Still destroying... [id=i-0009d7ff9db0ca6da, 10s elapsed]
aws_instance.simple: Still destroying... [id=i-0009d7ff9db0ca6da, 20s elapsed]
aws_instance.simple: Destruction complete after 30s
aws_subnet.basic_subnet: Destroying... [id=subnet-0b39330072032211d]
aws_subnet.basic_subnet: Destruction complete after 0s
aws_vpc.basic: Destroying... [id=vpc-09299e894452e73e8]
aws_vpc.basic: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```



