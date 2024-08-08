## Overview

This is a feature bundle for various languages tuned to my particular likes in development using the homebrew package installer feature in a loop

```bash
for feature in "${features[@]}"; do
  $nanolayer_location \
      install \
      devcontainer-feature \
      "ghcr.io/devcontainers-contrib/features/homebrew-package:1.0.7" \
      --option package="$feature" --option version="$VERSION"
done
```
### `nodejs-dev`

A hyper-customized nodejs development image

## Example Usage

```json
"features": {
    "ghcr.io/devcontainers/feature-starter/nodejs-dev": {}
}
```


