# opendcdiag-arm-rpm-20.03

OpenDCDiag (ARM64) 离线构建依赖 RPM 包仓库 —— openEuler 20.03 LTS 系列。

按 OS 版本(基准 / SP1 / SP2 / SP3 / SP4)分子目录存放对应版本的 RPM,供无网络目标机离线安装。

## 目录结构

```
opendcdiag-arm-rpm-20.03/
├── README.md
├── openEuler-20.03LTS/         # 基准版
├── openEuler-20.03LTS_SP1/
├── openEuler-20.03LTS_SP2/
├── openEuler-20.03LTS_SP3/
└── openEuler-20.03LTS_SP4/
    每个子目录:
    ├── .os-version          # 版本标记(内容=目录名,install-deps.sh 严格核对)
    └── *.rpm                # 含完整依赖树
```

## 用法

本仓库作为 [opendcdiag-arm](https://github.com/wangxumarshall/opendcdiag-arm) 的 git submodule,路径 `third-party/rpms/openEuler-20.03`。目标机离线安装时:

```bash
cd third-party/rpms/openEuler-20.03/openEuler-20.03LTS_SP4
../../../../scripts/offline-build/install-deps.sh .
```

## 版本对应

以 `openEuler-24.03LTS_SP3` 包名列表为基准,在对应版本仓库取同名包 + 完整依赖树。

| OS 版本 | RPM 数量 | 基准包名交集 | 来源 |
|---|---|---|---|
| openEuler-20.03LTS | 420 | 314 / 326 | openEuler 20.03 LTS aarch64 仓库 |
| openEuler-20.03LTS_SP1 | 426 | 319 / 326 | openEuler 20.03 LTS SP1 aarch64 仓库 |
| openEuler-20.03LTS_SP2 | 425 | 319 / 326 | openEuler 20.03 LTS SP2 aarch64 仓库 |
| openEuler-20.03LTS_SP3 | 413 | 319 / 326 | openEuler 20.03 LTS SP3 aarch64 仓库 |
| openEuler-20.03LTS_SP4 | 413 | 319 / 326 | openEuler 20.03 LTS SP4 aarch64 仓库 |

> 基准缺失的包为该版本仓库未提供的较新组件(如 `boost-json`、若干 `-help` 文档子包),属版本本身差异,非下载缺失。下载机与目标机必须 openEuler 版本一致。
