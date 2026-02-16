
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMyPencilsAll(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  local transparent_groups = {
    -- Core windows
    "Normal",
    "NormalNC",
    "NormalFloat",

    -- Gutter / UI
    "SignColumn",
    "EndOfBuffer",
    "WinSeparator",

    -- Statusline
    "StatusLine",
    "StatusLineNC",

    -- Popup / menus
    "Pmenu",
    --"PmenuSel",
    "PmenuSbar",
    "PmenuThumb",

    -- Tabs
    "TabLine",
    "TabLineFill",
    "TabLineSel",
  }

  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

return {
	"rose-pine/neovim", 
	name = "rose-pine", 
	config = function()
		vim.cmd("colorscheme rose-pine")
		require('rose-pine').setup({
			disable_background = true
		})
		ColorMyPencils()
	end
}
