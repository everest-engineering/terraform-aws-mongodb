output "mongo_server_private_ip" {
  value = aws_instance.mongo_server.private_ip
}

output "mongo_server_public_ip" {
  value = aws_instance.mongo_server.public_ip
}
