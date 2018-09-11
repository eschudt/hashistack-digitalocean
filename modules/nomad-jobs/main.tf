# modules/nomad-jobs/main.tf
# Run nomad jobs

variable "nomad_server_ip" {
  description = "The ip address of a consul server"
}

variable "version" {
  default = "latest"
}

#null resource to ensure dependency of server and client modules
resource "null_resource" "dependency_manager" {
  triggers {
    dependency_id = "${var.nomad_server_ip}"
  }
}

# Configure the Nomad provider
provider "nomad" {
  address = "${var.nomad_server_ip}"
}

# Register a job
resource "nomad_job" "age-generator" {
  jobspec = "${data.template_file.job.rendered}"
}

data "template_file" "age-generator" {
  template = "${file("${path.root}/scripts/nomad/jobs/age-generator.nomad")}"

  vars {
    version = "${var.version}"
  }
}
