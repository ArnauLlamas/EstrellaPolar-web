include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "_meta" {
  path = "${get_repo_root()}/_common/units/meta.hcl"
}
