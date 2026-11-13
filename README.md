# luizribeiro/homebrew-tap

Homebrew formulae for my open-source projects.

```
brew install luizribeiro/tap/clipsy
```

Installing by the fully qualified name also marks that formula as
trusted, which Homebrew 6+ requires for formulae from third-party taps.
To install other formulae from this tap by their short names, trust the
whole tap first with `brew trust luizribeiro/tap`.

| Formula | Description |
| --- | --- |
| [clipsy](https://github.com/luizribeiro/clipsy) | Sync your clipboard across hosts |

Formulae build from the tagged source release, so the first install
also pulls in the build toolchain (e.g. `rust`).

## Releasing a new version

Formulae are bumped automatically when a project pushes a `v*` tag. A
project's release workflow calls the reusable workflow in this repo:

```yaml
jobs:
  homebrew:
    uses: luizribeiro/homebrew-tap/.github/workflows/bump-formula.yml@main
    with:
      formula: clipsy
    secrets:
      tap-token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

It downloads the tag's source tarball, rewrites the formula's `url` and
`sha256` with `bin/bump-formula`, and pushes the commit here.
`HOMEBREW_TAP_TOKEN` is a fine-grained token with *Contents: read and
write* on this repository, stored as a secret in the project repo.

## Adding a formula

1. Add `Formula/<name>.rb` pointing at the project's latest
   `archive/refs/tags/vX.Y.Z.tar.gz`.
2. Add the `homebrew` job above to the project's release workflow and
   the `HOMEBREW_TAP_TOKEN` secret to the project.
3. CI builds, tests and audits every formula on macOS and Linux.
