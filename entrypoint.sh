#!/bin/bash
cd /builddir
git clone https://github.com/coolsnowwolf/lede.git
cd lede
# Update feeds
echo "src-git small8 https://github.com/kenzok8/small-package" >> ./feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

# Download config file
wget -O .config https://cdn.pzwa.net/file/pzwashare/configabc

# Generate configuration file
make defconfig
# Make download
make download -j$(($(nproc) + 1))
find dl -size -1024c -exec rm -f {} \;

# Compile firmware
make -j$(($(nproc) + 1)) V=s

# Upload to B2
b2 sync --delete --replaceNewer ./bin/ b2://routerimg/
