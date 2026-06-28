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
                "clangd", "cmake", "omnisharp", "pyright", "rust_analyzer"
            },
            automatic_installation = true,
            -- mason-lspconfig 2.x auto-runs vim.lsp.enable() for installed servers
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- keymaps + per-client tweaks, applied to every attached server
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local opts = { buffer = bufnr }
                local keymap = vim.keymap.set
                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
                keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>gr", vim.lsp.buf.references, opts)
                keymap("i", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
                keymap("n", "[d", vim.diagnostic.goto_prev, opts)
                keymap("n", "]d", vim.diagnostic.goto_next, opts)

                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "rust_analyzer" and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end,
        })

        -- merged into every server config (nvim 0.11 native API)
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- C++ LSP setup
        vim.lsp.config("clangd", {
            cmd = { "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
                "--header-insertion=iwyu" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
        })

        -- C# LSP setup (OmniSharp via Mason for Linux/WSL)
        vim.lsp.config("omnisharp", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp",
                "-lsp",
            },
            root_markers = { "*.sln", "*.csproj" },
            settings = {
                FormattingOptions = {
                    EnableEditorConfigSupport = true,
                    OrganizeImports = true,
                },
                MsBuild = {
                    LoadProjectsOnDemand = true,
                },
                RoslynExtensionsOptions = {
                    EnableAnalyzersSupport = false,
                    EnableImportCompletion = true,
                    EnableDecompilationSupport = true,
                },
            },
        })

        -- Python LSP setup (Pyright)
        vim.lsp.config("pyright", {
            root_markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                ".git",
            },
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "basic", -- "off", "basic", "strict"
                    },
                },
            },
        })

        -- Rust LSP setup (rust-analyzer)
        vim.lsp.config("rust_analyzer", {
            filetypes = { "rust" },
            root_markers = { "Cargo.toml", "rust-project.json" },
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                    },
                    checkOnSave = {
                        command = "clippy",
                    },
                    inlayHints = {
                        parameterHints = { enable = true },
                        typeHints = { enable = true },
                    },
                },
            },
        })

        -- CMake LSP setup (cmake-language-server)
        vim.lsp.config("cmake", {
            filetypes = { "cmake" },
            root_markers = { "CMakeLists.txt", "cmake", ".git" },
            init_options = {
                buildDirectory = "build",
            },
        })

        -- ensure the servers we configured are turned on (idempotent with
        -- mason-lspconfig's automatic_enable)
        vim.lsp.enable({ "clangd", "omnisharp", "pyright", "rust_analyzer", "cmake" })
    end,
}
