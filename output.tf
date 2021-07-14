output "freeipa_userdata_snippet" {
  description = "Userdata snippet to be added to EC2 instance during bootstrap"
  value       = data.template_file.userdata_snippet.rendered
}