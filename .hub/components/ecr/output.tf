output "repository_url" {
  value = "${coalesce("${aws_ecr_repository.main.repository_url}", "** unset **")}"
}

output "name" {
  value = "${aws_ecr_repository.main.name}"
}

output "registry_id" {
  value = "${aws_ecr_repository.main.registry_id}"
}
