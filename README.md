# helm-template (legacy)

> ⚠️ **已迁移 / Deprecated**
>
> 新的 Helm chart monorepo 与 **OCI + GHCR** 发布方式请使用：
>
> **https://github.com/ohdat/helm-temp**
>
> OCI 地址：`oci://ghcr.io/ohdat/charts/<chart>`  
> 例如：`oci://ghcr.io/ohdat/charts/service`

## 为什么迁移

| 本仓库（旧） | 新仓库 [helm-temp](https://github.com/ohdat/helm-temp) |
|--------------|--------------------------------------------------------|
| 每个 chart 一个 git 分支（service / grpc / …） | 单 `main` + `charts/*` monorepo |
| chart-releaser + gh-pages | Helm OCI → GitHub Container Registry |
| 旧版 Helm workflow（3.4） | Helm ≥ 3.8 原生 OCI（推荐 3.14+） |

## 新用法（推荐）

```bash
# Helm ≥ 3.8.0
helm version

# 私有包需登录 GHCR（token 含 read:packages）
echo "$GITHUB_TOKEN" | helm registry login ghcr.io -u YOUR_GITHUB_USER --password-stdin

# 安装 HTTP 服务 chart（elevatrix.xyz）
helm upgrade --install http-creator oci://ghcr.io/ohdat/charts/service \
  --version 1.2.0 \
  -n backend \
  --set image.repository=ghcr.io/ohdat/creator:tag \
  --set 'gateway.hosts[0]=creator.elevatrix.xyz' \
  --set gateway.create=false \
  --set gateway.existingGateway=istio-system/elevatrix-gateway
```

已迁入的 chart：`service`、`grpc`、`tcpservice`、`socket`、`website`、`command`、`cronjob`、`jobs`、`bluegreen`。

完整说明见：https://github.com/ohdat/helm-temp/blob/main/README.md

## 本仓库状态

- **只读 / 遗留参考**，请勿再往此仓库加新 chart 或发版
- 历史分支（service、grpc、…）仍保留便于对照
- 新变更请提交到 **ohdat/helm-temp**

