-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "moon",
      transparent = true, -- ОБЯЗАТЕЛЬНО: включает прозрачность в самой теме
      styles = {
        sidebars = "transparent", -- Делает боковые панели прозрачными
        floats = "transparent", -- Делает всплывающие окна прозрачными
      },
    },
  },
}
