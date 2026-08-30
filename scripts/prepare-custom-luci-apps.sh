#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/lede-custom-luci-apps"
LEAN_LUCI_REF="${LEAN_LUCI_REF:-master}"
ISTORE_REF="${ISTORE_REF:-main}"
OPENLIST_REF="${OPENLIST_REF:-main}"

rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"

echo "Fetching luci-app-filetransfer from coolsnowwolf/luci@${LEAN_LUCI_REF}"
git clone --depth 1 --branch "${LEAN_LUCI_REF}" https://github.com/coolsnowwolf/luci.git "${WORK_DIR}/lean-luci"

mkdir -p "${ROOT_DIR}/feeds/luci/applications" "${ROOT_DIR}/feeds/luci/libs"
rm -rf \
  "${ROOT_DIR}/feeds/luci/applications/luci-app-filetransfer" \
  "${ROOT_DIR}/feeds/luci/libs/luci-lib-fs"

cp -a "${WORK_DIR}/lean-luci/applications/luci-app-filetransfer" "${ROOT_DIR}/feeds/luci/applications/"
cp -a "${WORK_DIR}/lean-luci/libs/luci-lib-fs" "${ROOT_DIR}/feeds/luci/libs/"

echo "Fetching luci-app-store from linkease/istore@${ISTORE_REF}"
git clone --depth 1 --branch "${ISTORE_REF}" https://github.com/linkease/istore.git "${WORK_DIR}/istore"

mkdir -p "${ROOT_DIR}/package/custom"
for package_name in luci-app-store luci-lib-taskd luci-lib-xterm taskd; do
  rm -rf "${ROOT_DIR}/package/custom/${package_name}"
  cp -a "${WORK_DIR}/istore/luci/${package_name}" "${ROOT_DIR}/package/custom/"
done

echo "Fetching luci-app-openlist2 from sbwml/luci-app-openlist2@${OPENLIST_REF}"
git clone --depth 1 --branch "${OPENLIST_REF}" https://github.com/sbwml/luci-app-openlist2.git "${WORK_DIR}/openlist2"

for package_name in openlist2 luci-app-openlist2; do
  rm -rf "${ROOT_DIR}/package/custom/${package_name}"
  cp -a "${WORK_DIR}/openlist2/${package_name}" "${ROOT_DIR}/package/custom/"
done

echo "Custom LuCI packages are ready."
