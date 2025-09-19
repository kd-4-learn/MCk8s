# SpigotのビルドにはJREではなくJDKが必要なため、JDKを含むイメージを選択します
FROM eclipse-temurin:21-jdk-jammy

# 環境変数（サーバーのバージョンやメモリ割り当てなどをここで管理）
ENV MC_VERSION="1.21.1"
ENV JVM_OPTS="-Xms8G -Xmx8G"

# 作業ディレクトリを設定
WORKDIR /server

# 必要なツールをインストール (SpigotのBuildToolsはgitを必要とします)
RUN apt-get update && apt-get install -y wget git dos2unix

# SpigotのBuildToolsをダウンロードし、Spigotサーバーをビルドします
# --revでMinecraftのバージョンを指定します
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar && \
    java -jar BuildTools.jar --rev ${MC_VERSION}

# ビルドされたSpigotサーバーJARを、既存の起動スクリプトが使えるように `server.jar` にリネームします
# これにより、start.sh を変更する必要がなくなります
RUN mv spigot-${MC_VERSION}.jar server.jar

# EULA（利用許諾契約）に同意するファイルを作成
RUN echo "eula=true" > eula.txt

# 起動スクリプトをコンテナ内にコピー (既存のフローを維持)
COPY scripts/start.sh .
# 修正点：dos2unixコマンドで、Windowsの改行コード(CRLF)をLinux形式(LF)に変換します
RUN dos2unix start.sh
# 実行権限を付与
RUN chmod +x start.sh
RUN chmod +x start.sh

# サーバーデータやプラグインを永続化するためのボリュームを指定
VOLUME ["/server/world", "/server/plugins"]

# ポートを開放
EXPOSE 25565

# コンテナ起動時に実行するコマンド
CMD ["./start.sh"]

