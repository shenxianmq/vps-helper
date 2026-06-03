#!/usr/bin/env bash
set -Eeuo pipefail

REPO_RAW_URL="${REPO_RAW_URL:-https://raw.githubusercontent.com/shenxianmq/vps-helper/main}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/sbin}"

die() {
  echo "错误：$*" >&2
  exit 1
}

need_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    die "请使用 root 运行，例如：sudo ./install.sh ca"
  fi
}

need_writable_install_dir() {
  if [[ -d "$INSTALL_DIR" && -w "$INSTALL_DIR" ]]; then
    return 0
  fi
  need_root
}

install_ca() {
  need_writable_install_dir
  mkdir -p "$INSTALL_DIR"

  local src=""
  local self_dir=""
  self_dir="$(cd "$(dirname "${BASH_SOURCE[0]-}")" 2>/dev/null && pwd || true)"

  if [[ -n "$self_dir" && -f "$self_dir/bin/ca" ]]; then
    src="$self_dir/bin/ca"
    install -m 0755 "$src" "$INSTALL_DIR/ca"
  else
    command -v curl >/dev/null 2>&1 || die "需要先安装 curl"
    curl -fsSL "$REPO_RAW_URL/bin/ca" -o "$INSTALL_DIR/ca"
    chmod 0755 "$INSTALL_DIR/ca"
  fi

  echo "已安装 ca 到 $INSTALL_DIR/ca"
  echo "运行：sudo ca"
}

usage() {
  cat <<'EOF'
用法：
  sudo ./install.sh ca

从 GitHub 一键安装：
  curl -fsSL https://raw.githubusercontent.com/shenxianmq/vps-helper/main/install.sh | sudo bash -s -- ca
EOF
}

main() {
  case "${1:-}" in
    ca) install_ca ;;
    ""|-h|--help|help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
