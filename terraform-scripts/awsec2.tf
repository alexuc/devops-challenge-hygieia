variable "chef_provision" {
  type                      = "map"
  description               = "Configuration details for my chef server"

  default = {
    server_url              = "https://api.chef.io/organizations/alex-org"
    user_name               = "alexuc"
    user_chef_key           = "C:\\Users\\Alex\\my-chef\\.chef\\alexuc.pem"
    user_key_path           = "C:\\Users\\Alex\\my-chef\\.chef\\alex-org-validator.pem"
	centos_user_key_path    = "D:\\Alex\\Documents\\terraform\\AUCBuildMachine.pem"
    recreate_client         = true
  }
}

provider "aws" {
  access_key = "AKIAJII5NCFN5QUJBR6A"
  secret_key = "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"
  region     = "us-west-2"
}

variable "count" {
  default=3
}

resource "aws_instance" "myec2vm" {
  ami             = "ami-3ecc8f46"
  instance_type   = "t2.micro"
  key_name        = "AUCBuildMachine"
  vpc_security_group_ids = ["sg-082b20bdd8abcf0f5",]
  
  count           = "${var.count}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  
  tags {
    Name="${format("testvm-%01d",count.index+1)}"
  }

  provisioner "chef" {
    server_url      = "${var.chef_provision.["server_url"]}"
    user_name       = "${var.chef_provision.["user_name"]}"
    user_key        = "${file("${var.chef_provision.["user_chef_key"]}")}"
    node_name       = "ec2node-${count.index}"
    run_list        = ["auc-docker-maven::default"]
    recreate_client = "${var.chef_provision.["recreate_client"]}"
    on_failure      = "continue"
	
	connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("${var.chef_provision.["centos_user_key_path"]}")}"
    }
  }
}


output "address" {
  value = "${aws_instance.myec2vm.*.public_dns}"
}
