variable "s3_state_file" {
  default = {
    bucket        = "backstage-archive"
    force_destroy = true
    server_side_encryption_configuration = {
      rule = {
        apply_server_side_encryption_by_default = {
          kms_master_key_id = null
          sse_algorithm     = "AES256"
        }
      }
    }
    versioning = {
      status     = true
      mfa_delete = false
    }
    acl                      = "private"
    control_object_ownership = false
    object_ownership         = "BucketOwnerEnforced"
    tags = {
      "project_code" : "backstage"
    }
    force_destroy = true
  }
}