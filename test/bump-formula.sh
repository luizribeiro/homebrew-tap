#!/usr/bin/env bash
set -euo pipefail

bump=$(cd "$(dirname "$0")/.." && pwd)/bin/bump-formula
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT
failures=0

fail() {
  echo "FAIL: $1" >&2
  failures=$((failures + 1))
}

write_formula() {
  cat > "$workdir/clipsy.rb" <<'RUBY'
class Clipsy < Formula
  desc "Sync your clipboard across hosts"
  homepage "https://github.com/luizribeiro/clipsy"
  url "https://github.com/luizribeiro/clipsy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1111111111111111111111111111111111111111111111111111111111111111"
  license "MIT"
  revision 2

  resource "extra" do
    url "https://example.com/extra-1.0.tar.gz"
    sha256 "2222222222222222222222222222222222222222222222222222222222222222"
  end
end
RUBY
}

new_url="https://github.com/luizribeiro/clipsy/archive/refs/tags/v0.2.0.tar.gz"
new_sha="3333333333333333333333333333333333333333333333333333333333333333"

write_formula
"$bump" "$workdir/clipsy.rb" "$new_url" "$new_sha"
grep -qx "  url \"$new_url\"" "$workdir/clipsy.rb" || fail "top-level url not updated"
grep -qx "  sha256 \"$new_sha\"" "$workdir/clipsy.rb" || fail "top-level sha256 not updated"
grep -qx '    url "https://example.com/extra-1.0.tar.gz"' "$workdir/clipsy.rb" || fail "resource url was changed"
grep -qx '    sha256 "2222222222222222222222222222222222222222222222222222222222222222"' "$workdir/clipsy.rb" \
  || fail "resource sha256 was changed"
grep -q 'v0.1.0' "$workdir/clipsy.rb" && fail "old url still present"
grep -q '^  revision' "$workdir/clipsy.rb" && fail "revision should be dropped on a version bump"

write_formula
odd_url='https://example.com/a&b|c\d.tar.gz'
"$bump" "$workdir/clipsy.rb" "$odd_url" "$new_sha"
grep -qxF "  url \"$odd_url\"" "$workdir/clipsy.rb" || fail "url with special characters not written verbatim"

printf 'class Empty < Formula\nend\n' > "$workdir/empty.rb"
if "$bump" "$workdir/empty.rb" "$new_url" "$new_sha" 2>/dev/null; then
  fail "formula without url/sha256 should be rejected"
fi

if "$bump" "$workdir/clipsy.rb" 2>/dev/null; then
  fail "missing arguments should be rejected"
fi

[ "$failures" -eq 0 ] && echo "all bump-formula tests passed"
exit "$failures"
