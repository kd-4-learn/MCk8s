#!/bin/bash

# server.propertiesが存在しない場合、初回起動と判断し、一度サーバーを起動して設定ファイルを生成させる
if [ ! -f "server.properties" ]; then
    echo "server.properties not found. Running initial setup..."
    # 短時間だけ起動して、設定ファイルを自動生成させる
    timeout 10s java $JVM_OPTS -jar server.jar --initSettings nogui || true
fi

# メインのサーバープロセスを起動
# exec をつけることで、このスクリプトがサーバープロセスに置き換わり、Dockerがシグナルを正しくサーバーに送れるようになります。
exec java $JVM_OPTS -jar server.jar nogui