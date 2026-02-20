#!/bin/sh
# Automated installation script for Passwall2 on OpenWrt

opkg update
opkg remove dnsmasq
opkg install dnsmasq-full
opkg install kmod-nft-tproxy kmod-nft-socket

wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
wget -O /etc/apk/keys/passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
opkg-key add passwall.pub

read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF

for feed in passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done

opkg update
opkg install luci-app-passwall2 sing-box v2ray-geosite-ir

echo "Installation completed. Access LuCI at http://192.168.123.1/cgi-bin/luci"