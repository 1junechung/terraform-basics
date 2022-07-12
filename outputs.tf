output "instance_id" {
  value = aws_instance.foo.id
  sensitive = true
}
