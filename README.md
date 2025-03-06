# 概要

GitHub Organization上のOrganization及びチームのメンバーをTerraformとCSVによって管理します。

## 機能

* Organizationのメンバー管理
    * ロール管理(Onwer/Member)
* チームの新規作成
* チームのメンバー管理
    * ロール管理(Memtainer/Member)
    * 手動作成の既存チームのメンバー管理も可能
* Pull Requestによる承認フロー

## ディレクトリ/ファイル構成

```
.
├── .github/
│   └── workflows/ #GitHub Actionsのワークフローファイルの格納フォルダ
│       ├── apply.yml # Pull Requestマージ時に実行されるterraform apply用ワークフローファイル
│       └── plan.yml # Pull Request時に実行されるterraform plan用ワークフローファイル
├── shell/
│   └── script.sh # GitHub Appsトークン生成用シェルスクリプト
├── terraform/ #tfファイル格納用フォルダ
│   ├── module/
│   │   └── terraform-github-organization/ # Organizationのメンバー管理用モジュールフォルダ
│   │       ├── main.tf # モジュールのメインtfファイル
│   │       └── variables.tf # モジュールの変数用tfファイル
│   ├── .terraform.lock.hcl # terraform init時に自動生成されるプロバイダロックファイル
│   ├── organization.tf # モジュールに渡す引数を定義するtfファイル。チーム追加時などに更新するファイル
│   ├── README.md # organization.tfの内容を説明したREADMEファイル
│   └── versions.tf # terraform version、プロパイダー、バックエンドを指定するファイル
├── users/ #メンバー管理用のcsvファイルを格納するフォルダ
│   └── *.csv
├── .gitignore
└── README.md
```

## 引用

GitHub Appsトークン生成スクリプトとGitHub Actionsワークフロー上のGitHub Appsトークン生成に関するステップは下記の記事から引用しております。

https://zenn.dev/tmknom/articles/github-apps-token