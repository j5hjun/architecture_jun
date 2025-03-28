resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.name_prefix}-rds"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = false
  publicly_accessible     = false
  multi_az                = false
  final_snapshot_identifier = "${var.name_prefix}-rds-final-snapshot"
  
  tags = {
    Name = "${var.name_prefix}-rds"
  }
}
