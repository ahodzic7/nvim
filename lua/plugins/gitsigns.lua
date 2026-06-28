return {
  "lewis6991/gitsigns.nvim",

  config = function()
    require('gitsigns').setup({
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(m, l, r) vim.keymap.set(m, l, r, {buffer=bufnr}) end
        map('n', ']c', gs.next_hunk)
        map('n', '[c', gs.prev_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('n', '<leader>hb', function() gs.blame_line({full=true}) end)
      end,
    })
  end
}
