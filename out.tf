output "public_subnet_ids" {
  value = module.public_subnet_web_tr.public_subnet_ids
}
output "private_app_subnet_ids" {
  value = module.private_subnet_app_tr.private_subnet_ids
}
output "private_db_subnet_ids" {
  value = module.private_subnet_db_tr.private_subnet_ids
}