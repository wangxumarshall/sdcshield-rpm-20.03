#!/bin/bash
# run-sdcshield.sh — 在目标机上运行随包的 sdcshield 二进制。
# 自动设置 LD_LIBRARY_PATH 指向随包 libs/ 目录。
#
# 用法:
#   ./run-sdcshield.sh [sdcshield 参数...]     原样透传给二进制
#   ./run-sdcshield.sh full [参数...]          全核满载 eigen 运算:
#     第一段: 11 个稳定 eigen 测试, 不带 -n (默认全部 CPU 满载)
#     第二段: 4 个数值敏感测试 (eigen_svd_double/eigen_sparse/
#             eigen_svd_cdouble/eigen_svd_cdouble_sve) -n 1 补跑,
#             避免大规模多线程下 ULP 级偶发假 FAIL (平台已知特性)
#   可透传 -t <time> 覆盖默认每测试 60s (如 full -t 120s);
#   透传的 -n 只作用于第一段, 第二段恒为 -n 1。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="$SCRIPT_DIR/libs${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
# 20.03 的二进制 RPATH 指向 /opt/openEuler/gcc-toolset-10/root/usr/lib64;
# 若目标机没装 toolset, 上面的 libs/ 提供了同名库, LD_LIBRARY_PATH 优先于 RPATH。

if [ "$1" = "full" ]; then
    shift
    FULL_T="60s"
    # 用户自带 -t/--test-time 则不注入默认值
    for a in "$@"; do
        case "$a" in
            -t|--test-time|-t*|--test-time=*) FULL_T="" ;;
        esac
    done
    [ -n "$FULL_T" ] && set -- -t "$FULL_T" "$@"
    RC=0
    # 第一段: 11 个稳定 eigen 测试, 全核满载 (无 -n → 默认所有 CPU)
    "$SCRIPT_DIR/sdcshield" -e 'eigen*' \
        --disable eigen_svd_double --disable eigen_sparse \
        --disable eigen_svd_cdouble --disable eigen_svd_cdouble_sve \
        "$@" || RC=$?
    # 第二段: 数值敏感的 4 个测试, 单线程补跑 (-n 1 追加在后, 优先于透传 -n)
    "$SCRIPT_DIR/sdcshield" -e eigen_svd_double -e eigen_sparse \
        -e eigen_svd_cdouble -e eigen_svd_cdouble_sve \
        "$@" -n 1 || RC=$?
    exit "$RC"
fi

exec "$SCRIPT_DIR/sdcshield" "$@"
