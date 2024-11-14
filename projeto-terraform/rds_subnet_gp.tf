resource "aws_db_subnet_group" "fatcat_db_subnet_group" {
  name = "fatcat_db_subnet_group"
  subnet_ids = [
    aws_subnet.fatcat_private_database_subnet_1.id,
    aws_subnet.fatcat_private_database_subnet_2.id,
  aws_subnet.fatcat_private_database_subnet_3.id]

  tags = {
    Name = "fatcat_db_subnet_group"
  }

}