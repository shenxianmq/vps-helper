# VPS Helper

个人 VPS 运维辅助脚本集合。

这个仓库只保存可复用脚本。Cloudflare token、TLS 私钥、证书、`.env`
文件和目标机器生成的服务配置都不能提交到仓库。

## 安装 `ca`

`ca` 是一个交互式 Caddy 管理脚本，用来处理简单反向代理规则：

- 安装并启用 Caddy
- 安装 Cloudflare DNS 插件，用于泛域名证书
- 在目标机器本地保存 Cloudflare token
- 管理泛域名反向代理规则
- 管理固定域名反向代理规则
- 生成、校验、备份并重载 `/etc/caddy/Caddyfile`

从 GitHub 一键安装：

```bash
curl -fsSL https://raw.githubusercontent.com/shenxianmq/vps-helper/main/install.sh | sudo bash -s -- ca
```

从本地 clone 安装：

```bash
sudo ./install.sh ca
```

安装后运行：

```bash
sudo ca
```

## `ca` 快速使用

交互模式：

```bash
sudo ca
```

命令模式：

```bash
sudo ca bootstrap
sudo ca token set
sudo ca add-wildcard DOMAIN UPSTREAM
sudo ca add-fixed DOMAIN UPSTREAM
sudo ca apply
sudo ca test
sudo ca status
```

## 目标机器上的文件

`ca` 管理的规则文件放在：

```bash
/etc/ca-manager/rules.d/
```

Cloudflare token 只保存在目标机器：

```bash
/etc/caddy/secrets/cloudflare.env
```

当前生效的 Caddyfile 仍然是：

```bash
/etc/caddy/Caddyfile
```

每次应用配置前，`ca` 会备份当前 Caddyfile：

```bash
/etc/caddy/Caddyfile.before-ca.YYYYMMDDHHMMSS
```
