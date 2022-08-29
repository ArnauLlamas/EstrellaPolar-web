# This file is introduced to test the linter configuration of your setup
# do not commit or include it in the Terraform state


# This resource is an example to test the linter,
# most fields are expected to be wrong
resource "aws_db_instance" "test" {
  allocated_storage    = 20
  engine               = "aurorra"
  engine_version       = "9.0"
  instance_class       = "db.t1.micro"
  db_name              = "test_db"
  username             = "foo"
  password             = "bar"
  db_subnet_group_name = "aurora_subnets"
  parameter_group_name = "core01-testing-cluster-parameter-group"
}

# This resource is the continuation of the previous example,
# fields are expected to be correct
resource "aws_db_instance" "test2" {
  allocated_storage    = 20
  engine               = "aurora"
  engine_version       = "5.7"
  instance_class       = "db.t3.medium"
  db_name              = "test_db"
  username             = "foo"
  password             = "bar"
  db_subnet_group_name = "aurora-subnets"
  parameter_group_name = "core01-testing-parameter-group"
}