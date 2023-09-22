local M = {
  filetype = {
    css = {
      require("formatter.filetypes.css").prettier
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier
    },
    javascriptreact = {
      require("formatter.filetypes.javascriptreact").prettier
    },
    typescript = {
      require("formatter.filetypes.typescript").prettier
    },
    typescriptreact = {
      require("formatter.filetypes.typescriptreact").prettier
    },
    vue = {
      require("formatter.filetypes.vue").prettier
    },
    json = {
      require("formatter.filetypes.json").prettier
    },
    markdown = {
      require("formatter.filetypes.markdown").prettier
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  command = "FormatWriteLock"
})

return M
