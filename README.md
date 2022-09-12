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
owner="あなたの名前"
ec2_ami_id="起動するEC2のAMI ID"
```

```
$ terraform init -backend-config=backend.conf
$ terraform plan
$ terraform apply
```

### EC2作業

踏み台EC2サーバー(bastion)にキーペアでアクセス。
scpで踏み台EC2サーバーにキーペアを送信。
sshで踏み台EC2サーバーに入り、そこからprivate subnetにあるEC2にsshでアクセス。

apacheを起動する

```
$ sudo yum update
$ sudo yum install httpd
$ sudo systemctl start httpd.service
```