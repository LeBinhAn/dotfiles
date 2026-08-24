return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true, -- disables setting the background color.
      float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
    },
  },
  { "kepano/flexoki-neovim", name = "flexoki" },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
  {
    "arcticicestudio/nord-vim",
    name = "nord",
    priority = 1000,
  },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "nord",
      -- colorscheme = "tokyonight-day",
      -- colorscheme = "gruvbox",
      -- colorscheme = "kanagawa",
      colorscheme = "rose-pine-dawn",
      -- colorscheme = "catppuccin-frappe",
      -- colorscheme = "flexoki-light",
    },
  },
}
