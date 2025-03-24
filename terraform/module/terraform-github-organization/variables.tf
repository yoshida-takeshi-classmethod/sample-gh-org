variable "name" {
  type        = string
  description = "The name of the organization."
}

variable "owners" {
  type        = set(string)
  default     = []
  description = "List of owners."
}

variable "blocked_users" {
  type        = set(string)
  default     = []
  description = "List of blocked users."
}

variable "members" {
  type        = set(string)
  default     = []
  description = "List of members."
}

variable "teams" {
  type        = any
  default     = []
  description = "List of teams. This should be `teams` object."
}

variable "existing_teams" {
  type        = set(string)
  default     = []
  description = "List of existing team names"
}

locals {
  memberships = merge(
    { for u in var.owners : u => "admin" },
    { for u in var.members : u => "member" },
    {
      for u in setunion(
        flatten(local.teams[*].maintainers),
        flatten(local.teams[*].members)
      ) : u => "member" if ! contains(var.owners, u)
    }
  )

  # チーム設定の基本形
  teams = [
    for t in var.teams : merge({
      name        = ""
      description = ""
      visible     = true
      maintainers = []
      members     = []
    }, t)
  ]

  # 既存のTeamと新規のTeamを分離
  new_teams = { 
    for team in local.teams : team.name => team 
    if !contains(var.existing_teams, team.name)
  }

  teams_maintainers = flatten([
    for t in local.teams : [
      for u in t.maintainers : {
        team_name = t.name
        username  = u
        role      = "maintainer"
      }
    ]
  ])

  teams_members = flatten([
    for t in local.teams : [
      for u in t.members : {
        team_name = t.name
        username  = u
        role      = "member"
      }
    ]
  ])

  team_memberships = {
    for m in concat(local.teams_maintainers, local.teams_members) :
    "${m.team_name} ${m.username}" => m
  }

  users = setunion(
    var.owners,
    var.blocked_users,
    var.members,
    flatten(local.teams[*].maintainers),
    flatten(local.teams[*].members)
  )
}