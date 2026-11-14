#!/usr/bin/env bash
set -euo pipefail

bump=$(cd "$(dirname "$0")/.." && pwd)/bin/bump-cask
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT
failures=0

fail() {
  echo "FAIL: $1" >&2
  failures=$((failures + 1))
}

write_cask() {
  cat > "$workdir/weblounge.rb" <<'RUBY'
cask "weblounge" do
  version "0.1.0"
  sha256 "1111111111111111111111111111111111111111111111111111111111111111"

  url "https://github.com/luizribeiro/weblounge-client/releases/download/desktop-v#{version}/weblounge-#{version}.dmg"
  name "weblounge"

  app "weblounge.app"
end
RUBY
}

new_sha="3333333333333333333333333333333333333333333333333333333333333333"

write_cask
"$bump" "$workdir/weblounge.rb" "0.2.0" "$new_sha"
grep -qx '  version "0.2.0"' "$workdir/weblounge.rb" || fail "version not updated"
grep -qx "  sha256 \"$new_sha\"" "$workdir/weblounge.rb" || fail "sha256 not updated"
grep -qF 'desktop-v#{version}/weblounge-#{version}.dmg"' "$workdir/weblounge.rb" \
  || fail "url template was changed"
grep -q '0.1.0' "$workdir/weblounge.rb" && fail "old version still present"

write_cask
"$bump" "$workdir/weblounge.rb" '1.0.0&beta|2' "$new_sha"
grep -qxF '  version "1.0.0&beta|2"' "$workdir/weblounge.rb" \
  || fail "version with special characters not written verbatim"

printf 'cask "empty" do\nend\n' > "$workdir/empty.rb"
if "$bump" "$workdir/empty.rb" "0.2.0" "$new_sha" 2>/dev/null; then
  fail "cask without version/sha256 should be rejected"
fi

if "$bump" "$workdir/weblounge.rb" 2>/dev/null; then
  fail "missing arguments should be rejected"
fi

[ "$failures" -eq 0 ] && echo "all bump-cask tests passed"
exit "$failures"
