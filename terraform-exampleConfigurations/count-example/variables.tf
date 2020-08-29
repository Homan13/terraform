variable "aws_region" {
    description = "The AWS region to create things in."
    default     = "us-east-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
    default = {
        "eu-west-1" = "ami-b1cf19c6"
        "us-east-1" = "ami-02354e95b39ca8dec"
        "us-west-1" = "ami-3f75767a"
        "us-west-2" = "ami-21f78e11"
    }
}