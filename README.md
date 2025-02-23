## Overview

This is a feature bundle for various languages tuned to my particular likes in development using the homebrew package installer feature in a loop. Extensions then take that model to whatever
language is the focus (e.g. nodejs, python, etc)

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

#### Nodejs Usage

```json
"features": {
    "ghcr.io/borland502/devcontainer-features/nodejs-dev": {}
}
```

### Python Development Workspace

A hyper-customized python image

#### Python Usage

```json
"features": {
    "ghcr.io/borland502/devcontainer-features/python-dev": {}
}
```
