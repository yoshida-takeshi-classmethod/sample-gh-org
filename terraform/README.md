# organization.tf

モジュール(terraform-github-organization)に渡す引数を定義するtfファイルです。

## 例

```hcl
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

```

## 引数

| 名前 | タイプ | 説明 |
| --- | --- | --- |
| `name` | `string` | 組織の名前を指定します。 |
| `owners` | `list` | Owner（組織ロール）を指定します。例ではcsvを読み込んだlocal変数を指定する形としています。 |
| `members` | `list` | Member（組織ロール）を指定します。例ではcsvを読み込んだlocal変数を指定する形としています。 |
| `blocked_users` | `list` | ブロックユーザーを指定します。ブロックユーザーが存在しない場合は、この引数を利用する必要はありません。 |
| `existing_teams` | `list` | 手動で作成した既存のTeamsを指定します。**このTeamsの名前はslug形式で指定する必要があります。** |
| `teams` | `object` | Teamsを指定します。 オブジェクトの形式は、別途参照してください。 |

`teams`オブジェクトは以下のキーを持ちます。

| 名前 | タイプ | 説明 |
| --- | --- | --- |
| `name` | `string` | Teams名を指定してください。**手動で作成した既存のチームのメンバー管理をしたい場合は、existing_teamsの時と同様にslug形式で指定します。** |
| `description` | `string` | Teamsの説明を記載できます。 |
| `visible` | `bool` | チームを表示するかどうか指定できます。デフォルトは `true`です。 |
| `maintainers` | `list` | Maintainer(チームロール)を割り当てたいユーザーを指定します。<br>例ではcsvを読み込んだlocal変数を指定する形としています。 |
| `members` | `list` | Member(チームロール)を割り当てたいユーザーを指定します。<br>例ではcsvを読み込んだlocal変数を指定する形としています。 |
