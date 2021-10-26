# sam-s3www

AWS SAMで
S3バケットを作り
コンテンツを流し込む
最低限のプロジェクト。


# デプロイに必要なもの

* [AWS CLI](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2.html)
* [AWS SAM CLI](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html)
* [jq](https://stedolan.github.io/jq/download/)
* [yq](https://github.com/kislyuk/yq)

[AWS CloudShell](https://aws.amazon.com/jp/blogs/news/aws-cloudshell-command-line-access-to-aws-resources/)
からだと、AWS CLIとSAM CLIとjqは最初から入ってますので
`pip3 install --user -U yq`
だけでOKで、あとはこのレポジトリをgit cloneするだけ。


# デプロイ

まずSAMなので

```sh
sam build
sam deploy --guided  # 最初の1回。2回目以降は `sam deploy`
```
で、サンプルのWWWコンテンツを置くS3を作成します。

`sam deploy --guided`では以下の2つを除いてデフォルトでOK。

* `Parameter BucketName` は S3のバケット名なので、独自の名前をつけてください。
* `HelloFunction may not have authorization defined, Is this okay? [y/N]:` は `y`で。

無事スタックがデプロイされたら、Outputの
`S3URL` と `S3SecureURL` の値をメモしてください
(忘れてもポータルのCloudFormationの該当スタックの出力から見れます)。

次に、

```sh
./sync_contents.sh
```
でcontents/ 以下をS3に転送します。


# テスト

Outputの `S3URL` か `S3SecureURL` のURLに
ブラウザからアクセスしてみてください。


# 削除

実験が終わったら
```sh
./delete_stack.sh
```
で、S3の中身とスタックを削除してください。
