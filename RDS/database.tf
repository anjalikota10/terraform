resource "aws_db_subnet_group" "example" {
  name       = "my-db-subnet-group"
  subnet_ids = ["subnet-0a5844d9ed4f486f9", "subnet-0c4ae9f1457ec47c3"]  # Specify subnets in different AZs
}


resource "aws_db_instance" "example" {
  identifier            = "my-database"
  allocated_storage     = 20  # Specify the allocated storage in GB
  engine                = "mysql"
  engine_version        = "8.0.35"  # Specify the desired MySQL version
  instance_class        = "db.t3.micro"  # Specify the instance class
  username              = "admin"  # Specify the username for the master user
  password              = "vertex1234"  # Specify the password for the master user
  publicly_accessible   = true  # Set to true if you want the database to be publicly accessible
}
