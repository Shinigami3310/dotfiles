return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        qmlformat = {
          command = "/usr/lib/qt6/bin/qmlformat",
        },
      },
      formatters_by_ft = {
        qml = { "qmlformat" },
      },
    },
  },
}
