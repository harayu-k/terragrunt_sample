// s3モジュール用の設定ファイル
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/${path_relative_to_include()}"
}
