# Installing Passwall2 for Sing-box with Iran and International Traffic Split

## Introduction

This guide explains how to set up Passwall2 on OpenWrt with Sing-box and configure Rule Manager to split Iran and international traffic.
## 1️⃣ Connect to Router

```bash
ssh root@192.168.xx.xx
```

> Replace `192.168.xx.xx` with your router IP.

## 2️⃣ Update Package List

```bash
opkg update
```

## 3️⃣ Replace dnsmasq with dnsmasq-full

```bash
opkg remove dnsmasq
```
```bash
opkg install dnsmasq-full
```

## 4️⃣ Install Required Kernel Modules

```bash
opkg install kmod-nft-tproxy kmod-nft-socket
```

## 5️⃣ Add Passwall Public Key

```bash
wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
```
```bash
opkg-key add passwall.pub
```

## 6️⃣ Add Passwall Repository

```bash
read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF

for feed in passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done
```

## 7️⃣ Install Packages

```bash
opkg update
```
```bash
opkg install luci-app-passwall2 sing-box wget-ssl
```

## 8️⃣ Access LuCI Panel

```text
http://192.168.xx.xx/cgi-bin/luci
```

## Notes

* For scripts automation, see `scripts/install.sh`.


# Passwall2 Setup & Rule Manager: Iran and International Traffic Configuration

This guide explains how to set up Passwall2 on OpenWrt and configure Rule Manager to split Iran and international traffic.

## 1️⃣ Download Iran Geosite and GeoIP Files

SSH into your router and navigate to:

```bash
cd /usr/share/v2ray/
```

Then download the files:

```text
Iran Geosite
```
```bash
wget https://cdn.jsdelivr.net/gh/Chocolate4U/Iran-sing-box-rules@rule-set/geosite-ir.srs
```
```text
Iran GeoIP
```
```bash
wget https://cdn.jsdelivr.net/gh/Chocolate4U/Iran-sing-box-rules@rule-set/geoip-ir.srs
```

## 2️⃣ Create a New Rule in Passwall2

1. Go to **Passwall2 → Rule Manager**.
2. Click **Add Rule** or **Create New Rule**.
3. Rule name: `IranIPsExceptions`
4. Settings:

| Type            | Value                                                                                              |
| --------------- | -------------------------------------------------------------------------------------------------- |
| Domain rule-set | `remote:https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geosite-ir.srs` |
| IP rule-set     | `remote:https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geoip-ir.srs`   |

## 3️⃣ Automatic Rule Update

In the same **Rule Manager** page, set the following fields:

| Type               | Value                     |
| ------------------ | ------------------------- |
| GeoIP Update URL   | `Chocolate4U/geoIP (IR)`  |
| Geosite Update URL | `Chocolate4U/gesite (IR)` |

> With these settings, Passwall2 will automatically split Iran and international traffic, and any rule updates will be applied automatically.
4️⃣ Configure Node and Shunt

After creating the IranIPsExceptions rule:

Go to Passwall2 → Node.

Create a Shunt node.

Set IranIPsExceptions rule to Direct in the Shunt.

Set the Default node to your main node (the default proxy or main connection).

This ensures all traffic matching IranIPsExceptions goes direct while all other traffic follows the default node.

## Notes

* Written and maintained by AmirJhd-dev.
* Inspired by official OpenWrt and Passwall2 documentation.
