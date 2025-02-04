# llmcat.nvim

[llmcat.nvim](https://github.com/doganarif/llmcat.nvim) is a Neovim plugin that integrates [llmcat](https://github.com/azer/llmcat) into Neovim.

## Overview

`llmcat.nvim` is a fast and flexible Neovim extension that integrates the `llmcat` command-line tool into your editor. With this plugin, you can:

- Copy specific file content or entire directories for large language models.
- Use interactive fuzzy search to select files (if configured).
- Automatically download and install the `llmcat` binary if it’s not already installed on your system.
- Run `llmcat` in a floating terminal window so that its built-in interactive keybindings work as expected.

## Installation

### Using packer.nvim

Add the following to your packer configuration:

```lua
use {
  'doganarif/llmcat.nvim',
  config = function()
    require('llmcat')
  end,
  build = function()
    require("llmcat.installer").ensure_installed()
  end
}

