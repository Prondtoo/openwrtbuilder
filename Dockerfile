FROM ubuntu:latest
ENV TZ=UTC
ENV CONFIG_URL="https://cdn.pzwa.net/file/pzwashare/configabc"
ENV B2_APPLICATION_KEY_ID=""
ENV B2_APPLICATION_KEY=""
ARG UNAME=openwrt
ARG UID=1120
ARG GID=1121
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME


USER root
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 切换中国源
RUN sed -i s@/archive.ubuntu.com/@/mirrors.huaweicloud.com/@g /etc/apt/sources.list
RUN sed -i s@/security.ubuntu.com/@/mirrors.huaweicloud.com/@g /etc/apt/sources.list

RUN  apt-get update
RUN  apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync
RUN  apt-get clean

# Install B2 Client
RUN wget -O /usr/bin/b2 https://github.com/Backblaze/B2_Command_Line_Tool/releases/latest/download/b2-linux
RUN chmod a+x /usr/bin/b2
RUN mkdir -p /builddir
COPY entrypoint.sh /builddir
RUN chmod 777 /builddir/entrypoint.sh
RUN chown -R 1120:1121 /builddir
USER $UNAME
ENTRYPOINT ["/builddir/entrypoint.sh"]
