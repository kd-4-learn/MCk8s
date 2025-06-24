# ベースイメージとしてJava 17が使える公式イメージを選択
FROM eclipse-temurin:17-jre-jammy

# 環境変数（サーバーのバージョンやメモリ割り当てなどをここで管理）
ENV MC_VERSION="1.21"
ENV JVM_OPTS="-Xms2G -Xmx4G"

# 作業ディレクトリを設定
WORKDIR /server

# 必要なツールをインストールし、サーバーjarをダウンロード
RUN apt-get update && apt-get install -y wget && \
    wget https://piston-data.mojang.com/v1/objects/6e64dcabba3c01a7271b4fa6bd898483b794c59b/server.jar -O server.jar

# EULA（利用許諾契約）に同意するファイルを作成
# これがないとサーバーは起動しません
RUN echo "eula=true" > eula.txt

# 起動スクリプトをコンテナ内にコピー
COPY scripts/start.sh .
RUN chmod +x start.sh

# サーバーデータ（ワールドなど）を永続化するためのボリュームを指定
VOLUME /server/world
# プラグインを入れる場合
# VOLUME /server/plugins

# ポートを開放
EXPOSE 25565

# コンテナ起動時に実行するコマンド
CMD ["./start.sh"]