terraform {
  required_version = ">= 1.1.0"
  cloud {
    organization = "weaveworks"

    workspaces {
      name = "hello-world"
    }
  }
}

variable "subject" {
   type = string
   default = "World"
   description = "Subject to hello"
}

output "greeting" {
  value = "Hello again, ${var.subject}!"
}
