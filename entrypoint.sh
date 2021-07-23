#!/bin/bash
set -euf -o pipefail

# Perform the actual Python building and installing
# Ideally we're currently in an empty directory
INSTALL_DIR="${INSTALL_DIR:-$(mktemp -d)}"
VERSION="${VERSION:-3.7.10}"
URL=https://www.python.org/ftp/python/"$VERSION"/Python-"$VERSION".tar.xz

mkdir -vp "$INSTALL_DIR"

CURL_FLAGS=("-L")
[ -t 1 ] && CURL_FLAGS+=("-#") || CURL_FLAGS+=("-sS")

echo "Downloading and extracting: $URL"
echo "    into current directory: $(pwd)"
curl "${CURL_FLAGS[@]}" "$URL" \
| tar --strip-components=1 -xJ

./configure --prefix="$INSTALL_DIR" --with-pydebug --enable-shared
LD_RUN_PATH='$ORIGIN/../lib:'"$INSTALL_DIR"/lib make -s -j"$(nproc)"
make -s -j"$(nproc)" install

# Ensure all libraries are linked properly. Exit 1 if any libraries are "not found"
LDD_RESULTS="$(mktemp)"
ldd -v "$INSTALL_DIR"/bin/python"${VERSION%%.*}" > "$LDD_RESULTS"
grep -q "not found" "$LDD_RESULTS" || exit 0

grep "not found" "$LDD_RESULTS"
echo "----- from: ldd -v "$INSTALL_DIR"/bin/python"${VERSION%%.*}" -----"
cat "$LDD_RESULTS"
exit 1