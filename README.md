# web_db_infra
web db infra repository

https://github.com/katsuya-n/alb_maintenance_infra
をベースに作成。

# 事前準備

tfstateを置くためのS3バケットを作成しておく。
 
EC2にアクセスできるようにキーペアを作成しておく。

# 初期構築

```
$ cd app/
$ touch backend.conf
$ touch terraform.tfvars
```

以下をbackend.confに記載

```
bucket = "[バケット名]"
key = "[キー名]"
region = "[リージョン名]"
```

以下をterraform.tfvarsに記載

```
allow_cidr_block="[EC2とALBにアクセスしたいIPアドレス]"
key_name="[作成したキーペアのID]
```

```
$ terraform init -backend-config=backend.conf
$ terraform plan
$ terraform apply
```