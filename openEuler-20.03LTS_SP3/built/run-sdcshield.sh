#!/bin/bash
# run-sdcshield.sh — 在目标机上运行随包的 sdcshield 二进制。
# 自动设置 LD_LIBRARY_PATH 指向随包 libs/ 目录。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="$SCRIPT_DIR/libs${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
# 20.03 的二进制 RPATH 指向 /opt/openEuler/gcc-toolset-10/root/usr/lib64;
# 若目标机没装 toolset, 上面的 libs/ 提供了同名库, LD_LIBRARY_PATH 优先于 RPATH。
exec "$SCRIPT_DIR/sdcshield" "$@"
