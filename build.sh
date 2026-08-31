#!/usr/bin/env bash
#
# Build the site with the zola version this site actually works with.
#
# zola 0.23 replaced Tera 1 with Tera 2, which removed {% macro %}. The tabi
# theme still uses macros, so a newer zola (the one Arch ships, for instance)
# will not build this site. Keep ZOLA_VERSION in sync with the same variable in
# .github/workflows/static.yml.
#
# Usage:
#   ./build.sh          # zola build
#   ./build.sh serve    # or any other zola subcommand, args are passed through

set -euo pipefail

ZOLA_VERSION="0.22.1"
INSTALL_DIR="${HOME}/.local/bin"
PINNED_BIN="${INSTALL_DIR}/zola-${ZOLA_VERSION%.*}"

cd "$(dirname "$0")"

# Prints the version of a zola binary, e.g. "0.22.1".
zola_version() {
    "$1" --version 2>/dev/null | awk '{print $2}'
}

find_zola() {
    local candidate
    for candidate in "${ZOLA:-}" "$PINNED_BIN" "$(command -v zola || true)"; do
        [ -n "$candidate" ] && [ -x "$candidate" ] || continue
        if [ "$(zola_version "$candidate")" = "$ZOLA_VERSION" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

install_zola() {
    local url="https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    echo "zola ${ZOLA_VERSION} not found, installing it to ${PINNED_BIN}" >&2
    mkdir -p "$INSTALL_DIR"
    curl -sSfL "$url" | tar xz -C "$INSTALL_DIR" zola
    mv -f "${INSTALL_DIR}/zola" "$PINNED_BIN"
    chmod +x "$PINNED_BIN"
}

if ! ZOLA_BIN="$(find_zola)"; then
    install_zola
    ZOLA_BIN="$PINNED_BIN"
fi

echo "Using ${ZOLA_BIN} ($(zola_version "$ZOLA_BIN"))" >&2
exec "$ZOLA_BIN" "${@:-build}"
