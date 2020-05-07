output "mongo_server_public_ip" {
  value = aws_instance.mongo_server.public_ip
}

output "mongo_connect_url" {
  value = "mongodb://${aws_instance.mongo_server.public_ip}:27017"
}
