locals {
  owners     = csvdecode(file("../users/owners.csv"))
  members    = csvdecode(file("../users/members.csv"))
  test-team  = csvdecode(file("../users/test-team.csv"))
  exsit-team = csvdecode(file("../users/exsit-team.csv"))
}

module "organization" {
  source = "./module/terraform-github-organization"

  name = "example"

  owners  = local.owners[*].username
  members = local.members[*].username

  existing_teams = ["exist-team"]

  teams = [
    {
      name    = "Test Team"
      members = local.test-team[*].username
    },
    {
      name    = "exist-team"
      members = local.exsit-team[*].username
    }
  ]
}