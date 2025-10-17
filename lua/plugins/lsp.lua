return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
    },

    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd", "cmake", "omnisharp"
            },
            automatic_installation = true,
        })

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Define on_attach ONCE to use for all servers
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }
            local keymap = vim.keymap.set
            keymap("n", "gd", vim.lsp.buf.definition, opts)
            keymap("n", "K", vim.lsp.buf.hover, opts)
            keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap("n", "<leader>gr", vim.lsp.buf.references, opts)
            keymap("n", "[d", vim.diagnostic.goto_prev, opts)
            keymap("n", "]d", vim.diagnostic.goto_next, opts)
        end

        -- C++ LSP setup
        lspconfig.clangd.setup({
            cmd = { "clangd" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- C# LSP setup (OmniSharp via Mason for Linux/WSL)
        lspconfig.omnisharp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj"),
            cmd = { vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp", "-lsp" },
        })

        -- Autocompletion setup
        local cmp = require("cmp")
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
            },
        })
    end,
}
