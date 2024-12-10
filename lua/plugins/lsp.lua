return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp", -- Optional: Autocompletion support
        "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
        "L3MON4D3/LuaSnip", -- Optional: Snippets support
    },

    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
            },
            automatic_installation = true,
        })

        -- 3. LSP Configuration for clangd
        local lspconfig = require("lspconfig")

        -- Optional: Add completion capabilities if nvim-cmp is installed
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.clangd.setup({
            cmd = { "clangd" }, -- Use clangd LSP
            filetypes = { "c", "cpp", "objc", "objcpp" }, -- Filetypes handled
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
            capabilities = capabilities, -- Autocompletion capabilities
            on_attach = function(client, bufnr)
                -- Key mappings for LSP functions
                local opts = { buffer = bufnr }
                local keymap = vim.keymap.set

                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
                keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>gr", vim.lsp.buf.references, opts)
                keymap("n", "[d", vim.diagnostic.goto_prev, opts)
                keymap("n", "]d", vim.diagnostic.goto_next, opts)
            end,
        })

        -- 4. Autocompletion setup (optional)
        local cmp = require("cmp")
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion menu
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
            }),
            sources = {
                { name = "nvim_lsp" }, -- Use LSP as completion source
                { name = "buffer" },   -- Buffer completions
            },
        })
    end,
}
