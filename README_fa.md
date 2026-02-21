# نصب Passwall2 برای Sing-box با تفکیک ترافیک ایران و بین‌الملل

## Introduction

این راهنما نحوه راه‌اندازی Passwall2 روی OpenWrt همراه با Sing-box و تنظیم Rule Manager برای تفکیک ترافیک ایران و بین‌الملل را توضیح می‌دهد.

محیط تست و تأیید شده:

OpenWrt: 24.10.5

Passwall2: 26.2.14

Sing-box: 1.12.22
## 1️⃣ اتصال به روتر

```bash
ssh root@192.168.xx.xx
```

> مقدار `192.168.xx.xx` را با IP روتر خود جایگزین کنید.

## 2️⃣ بروزرسانی لیست پکیج‌ها

```bash
opkg update
```

## 3️⃣ جایگزینی dnsmasq با dnsmasq-full

```bash
opkg remove dnsmasq
```
```bash
opkg install dnsmasq-full
```

## 4️⃣ نصب ماژول‌های موردنیاز کرنل

```bash
opkg install kmod-nft-tproxy kmod-nft-socket
```

## 5️⃣ افزودن کلید عمومی Passwall

```bash
wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
```
```bash
opkg-key add passwall.pub
```

## 6️⃣ افزودن مخزن Passwall

```bash
read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF

for feed in passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done
```

## 7️⃣ نصب پکیج‌ها

```bash
opkg update
```
```bash
opkg install luci-app-passwall2 sing-box wget-ssl
```

## 8️⃣ ورود به پنل LuCI

```text
http://192.168.xx.xx/cgi-bin/luci
```

## Notes

* برای نصب خودکار می‌توانید از `scripts/install.sh` استفاده کنید.


# تنظیم Passwall2 و Rule Manager برای تفکیک ترافیک ایران و بین‌الملل

این بخش نحوه تنظیم Passwall2 در OpenWrt و پیکربندی Rule Manager برای تفکیک ترافیک ایران و بین‌الملل را توضیح می‌دهد.

## 1️⃣ دانلود فایل‌های Geosite و GeoIP ایران

از طریق SSH وارد روتر شوید و به مسیر زیر بروید:

```bash
cd /usr/share/v2ray/
```

سپس فایل‌ها را دانلود کنید:

## Iran Geosite

```bash
wget https://cdn.jsdelivr.net/gh/Chocolate4U/Iran-sing-box-rules@rule-set/geosite-ir.srs
```
## Iran GeoIP

```bash
wget https://cdn.jsdelivr.net/gh/Chocolate4U/Iran-sing-box-rules@rule-set/geoip-ir.srs
```

## 2️⃣ ایجاد Rule جدید در Passwall2

1. وارد **Passwall2 → Rule Manager** شوید.
2. روی **Add Rule** یا **Create New Rule** کلیک کنید.
3. نام Rule را `IranIPsExceptions` قرار دهید.
4. تنظیمات را مطابق جدول زیر وارد کنید:

| Type            | Value                                                                                              |
| --------------- | -------------------------------------------------------------------------------------------------- |
| Domain rule-set | `remote:https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geosite-ir.srs` |
| IP rule-set     | `remote:https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geoip-ir.srs`   |

## 3️⃣ بروزرسانی خودکار Ruleها

در همان صفحه **Rule Manager** مقادیر زیر را تنظیم کنید:

| Type               | Value                     |
| ------------------ | ------------------------- |
| GeoIP Update URL   | `Chocolate4U/geoIP (IR)`  |
| Geosite Update URL | `Chocolate4U/gesite (IR)` |

> با این تنظیمات، Passwall2 به‌صورت خودکار ترافیک ایران و بین‌الملل را تفکیک کرده و بروزرسانی Ruleها نیز به شکل اتوماتیک اعمال می‌شود.
4️⃣ تنظیم Node و Shunt

پس از ایجاد Rule با نام IranIPsExceptions:

وارد Passwall2 → Node شوید.

یک Shunt Node ایجاد کنید.

Rule مربوط به IranIPsExceptions را در Shunt روی حالت Direct قرار دهید.

Default Node را روی نود اصلی خود (پروکسی یا اتصال اصلی) تنظیم کنید.

در این حالت، تمام ترافیک منطبق با IranIPsExceptions به‌صورت مستقیم ارسال شده و سایر ترافیک‌ها از طریق نود پیش‌فرض عبور خواهند کرد.

## Notes
. Written and maintained by AmirJhd-dev.
. Inspired by official OpenWrt and Passwall2 documentation.
