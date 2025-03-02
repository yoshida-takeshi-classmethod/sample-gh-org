data "github_user" "main" {
  for_each = local.users
  username = each.key
}

# 既存のTeamを取得するデータソース
data "github_team" "existing" {
  for_each = local.existing_teams_map
  slug     = each.value
}

provider "github" {
  owner = var.name
}

resource "github_membership" "main" {
  for_each = local.memberships
  username = each.key
  role     = each.value
}

resource "github_organization_block" "main" {
  for_each = var.blocked_users
  username = each.key
}

# 新規のTeamのみを作成するリソース
resource "github_team" "main" {
  for_each    = local.new_teams
  name        = each.key
  description = each.value.description
  privacy     = each.value.visible ? "closed" : "secret"
}

# Team membership の設定を既存・新規両方に対応
resource "github_team_membership" "main" {
  depends_on = [github_membership.main]

  for_each = local.team_memberships
  team_id  = contains(var.existing_teams, each.value.team_name) ? data.github_team.existing[each.value.team_name].id : local.team_ids[each.value.team_name]
  username = each.value.username
  role     = each.value.role
}