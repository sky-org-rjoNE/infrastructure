module "s3" {
  source                               = "terraform-aws-modules/s3-bucket/aws"
  bucket                               = var.s3_state_file.bucket
  control_object_ownership             = var.s3_state_file.control_object_ownership
  object_ownership                     = var.s3_state_file.object_ownership
  server_side_encryption_configuration = var.s3_state_file.server_side_encryption_configuration
  tags                                 = var.s3_state_file.tags
  versioning                           = var.s3_state_file.versioning
  force_destroy                        = var.s3_state_file.force_destroy
}
