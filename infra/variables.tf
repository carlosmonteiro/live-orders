variable "account" {
  default = "327498361889"
}

variable "project_name" {
  default = "live-orders"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "avail_zone_1" {
  default = "us-east-1a"
}

variable "avail_zone_2" {
  default = "us-east-1b"
}

variable "private_subnet_1_cidr_block" {
  default = "10.0.3.0/24"
}

variable "public_subnet_1_cidr_block" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr_block" {
  default = "10.0.2.0/24"
}

variable "alb_sg_port" {
  default = "80"
}

variable "container_port" {
  default = "80"
}

variable "awslogs_region" {
  default = "us-east-1"
}

variable "health_check_path" {
  default = "/"
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "512"
}

variable "s3_env_vars_file_arn" {
  default = "arn:aws:s3:::live-orders-327498361889/vars.env"
}

variable "docker_image_name" {
  default = "nginx:latest"
}