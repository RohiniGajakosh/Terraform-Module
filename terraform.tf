terraform {
  cloud {
    organization = "rohini-org"

    workspaces {
      project = "ExamTerraform"
      name    = "ExamPrep"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = "~>1.14.3"

}

