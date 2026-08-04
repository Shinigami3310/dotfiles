return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- Плагин должен загружаться сразу при старте
  priority = 1000, -- Высокий приоритет, чтобы загрузиться до цветовой схемы
  opts = {
    -- Список дополнительных групп, которые нужно сделать прозрачными
    extra_groups = {
      "NormalFloat", -- Всплывающие окна (LSP подсказки, автокомплит)
      "FloatBorder", -- Границы всплывающих окон
      "NeoTreeNormal", -- Дерево файлов Neo-tree (дефолтное в LazyVim)
      "NeoTreeNormalNC", -- Неактивное дерево файлов Neo-tree
      "NeoTreeWinSeparator", -- Разделитель для Neo-tree
      "BufferLineWidget", -- Панель вкладок
      "BufferLineBackground",
      "BufferLineFill",
    },
    exclude_groups = {}, -- Оставьте пустым
  },
}
