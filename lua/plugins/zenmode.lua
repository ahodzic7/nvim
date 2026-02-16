return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      window = {
        options = {},
      },

      on_open = function()
        ColorMyPencilsAll()
      end,

      on_close = function()
        ColorMyPencils()
      end,
    })

    vim.keymap.set("n", "<leader>zz", function()
      require("zen-mode").toggle({
        window = { width = 90 },
      })

      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end)
  end,
}
