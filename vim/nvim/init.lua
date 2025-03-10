-- plugins manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- leader keys
vim.g.mapleader = " " -- "space"
vim.g.maplocalleader = ","

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- search, and clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- mode is already in status line, don't show it
vim.opt.showmode = false

-- set separator characters
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- load plugins
require("lazy").setup({
  { -- theme
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  { -- syntax
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true,
        ensure_installed = { "lua", "vim", "vimdoc", "regex", "markdown" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  { -- show file context
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
    config = function()
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
    end,
  },
  { -- fuzzy finder
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
    }
  },
  { -- comment lines
    "numToStr/Comment.nvim",
    opts = {}
  },
  { -- list of todos
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  { -- report errors
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { -- status line
    "nvim-lualine/lualine.nvim",
  },
  { -- todo.txt support
    "freitass/todo.txt-vim"
  },
  { -- git
    "tpope/vim-fugitive"
  },
  { -- indent helper
    "echasnovski/mini.indentscope",
    version = false,
  },
  { -- project tree
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },
  { -- git commit
    "rhysd/committia.vim"
  },
  { -- git status in files
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Hunk Stage" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Hunk Reset" })
          map("v", "<leader>hs", function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "Visual Hunk Stage" })
          map("v", "<leader>hr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "Visual Hunk Reset" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Hunk Undo Stage" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Hunk Preview" })
          map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "Hunk Blame" })
          map("n", "<leader>h]", gitsigns.next_hunk, { desc = "Hunk Next" })
          map("n", "<leader>h[", gitsigns.prev_hunk, { desc = "Hunk Previous" })
        end
      })
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true
  },
  { -- automatically open/close braces
    "Raimondi/delimitMate"
    -- TODO: change to another one
  },
  { -- lsp installer
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  { -- autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/cmp-buffer" },                             -- use text in buffer
      { "https://codeberg.org/FelipeLema/cmp-async-path" }, -- filesystem path
      { "hrsh7th/cmp-nvim-lsp-signature-help" },            -- current parameter from signature
      { "hrsh7th/cmp-nvim-lua" },                           -- neovim lua api
      { "hrsh7th/cmp-emoji" },                              -- emoji
      { "onsails/lspkind.nvim" },                           -- pictograms
      { "hrsh7th/cmp-calc" },                               -- calc
      {                                                     -- relative dates
        "Gelio/cmp-natdat",
        config = true
      },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        preselect = "item",
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = "...",
            -- TODO: improve menu layout
          })
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<ScrollWheelUp>"] = cmp.mapping.scroll_docs(-6),
          ["<ScrollWheelDown>"] = cmp.mapping.scroll_docs(6),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = {
          completeopt = "menu,menuone,noinsert"
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip",                keyword_length = 2 },
          { name = "buffer",                 keyword_length = 3 },
          { name = "async_path" },
          { name = "emoji" },
          { name = "calc" },
          { name = "natdat" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })
    end
  },
  { -- lsp config
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } }
      },
      { "b0o/schemastore.nvim" },
      { -- lsp status
        "j-hui/fidget.nvim",
        tag = "v1.0.0",
        opts = {
          progress = {
            display = {
              render_limit = false, -- How many LSP messages to show at once
              done_ttl = 5, -- How long a message should persist after completion
              done_icon = "✅", -- Icon shown when all LSP progress tasks are complete
              done_style = "Constant", -- Highlight group for completed LSP tasks
              progress_ttl = math.huge, -- How long a message should persist when in progress
              progress_icon = {
                pattern = {
                  -- mix of "bouncingBall" and "point" from https://github.com/sindresorhus/cli-spinners
                  "●∙∙∙∙∙",
                  "∙●∙∙∙∙",
                  "∙∙●∙∙∙",
                  "∙∙∙●∙∙",
                  "∙∙∙∙●∙",
                  "∙∙∙∙∙●",
                  "∙∙∙∙●∙",
                  "∙∙∙●∙∙",
                  "∙∙●∙∙∙",
                  "∙●∙∙∙∙",
                },
                period = 1
              },
              progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
              group_style = "Title",         -- Highlight group for group name (LSP server name)
              icon_style = "Question",       -- Highlight group for group icons
            },
          },

        },
      },
      { -- show when code action is available
        "kosayoda/nvim-lightbulb"
      },
      { -- vscode icons (required nerdfont)
        "mortepau/codicons.nvim"
      },
    },
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
    config = function()
      -- register icons
      local codicons = require("codicons")
      local signs = {
        { name = "DiagnosticSignError", text = codicons.get("error") },
        { name = "DiagnosticSignWarn",  text = codicons.get("warning") },
        { name = "DiagnosticSignHint",  text = codicons.get("lightbulb") },
        { name = "DiagnosticSignInfo",  text = codicons.get("info") },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- show when code action is available
      require("nvim-lightbulb").setup({
        autocmd = {
          enabled = true,
        },
        sign = {
          text = codicons.get("lightbulb-sparkle")
        },
      })

      -- define default lsp capabilities
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local default_setup = function(server)
        require("lspconfig")[server].setup({
          capabilities = lsp_capabilities,
        })
      end

      local lspconfig = require("lspconfig")

      -- configure lsp installed with mason
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "taplo", "jsonls" },
        automatic_installation = true,
        handlers = {
          -- default lsp setup
          default_setup,

          -- rust
          rust_analyzer = function()
            lspconfig.rust_analyzer.setup({
              settings = {
                ["rust-analyzer"] = {
                  check = {
                    command = "clippy"
                  },
                  cargo = {
                    buildScripts = {
                      enable = true,
                    },
                    features = "all",
                  },
                  procMacro = {
                    enable = true
                  },
                }
              }
            })
          end,

          -- json schema
          jsonls = function()
            lspconfig.jsonls.setup({
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
          end,

          -- lua
          lua_ls = function()
            local runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")

            local config = {
              settings = {
                Lua = {
                  -- Disable telemetry
                  telemetry = { enable = false },
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    path = runtime_path,
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" }
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      -- Make the server aware of Neovim runtime files
                      vim.fn.expand("$VIMRUNTIME/lua"),
                      vim.fn.stdpath("config") .. "/lua"
                    }
                  }
                }
              }
            }

            local lua_opts = vim.tbl_deep_extend("force", config, {})
            lspconfig.lua_ls.setup(lua_opts)
          end,

          -- tailwind with support for rust
          tailwindcss = function()
            lspconfig.tailwindcss.setup({
              settings = {
                includeLanguages = {
                  rust = "html",
                },
              },
              filetypes = {
                "rust",
              },
            })
          end,

          -- typescript
          -- for .ts and .js files, use ts_ls
          -- for .vue files, use volar
          ts_ls = function()
            local mason_registry = require("mason-registry")
            local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() ..
                "/node_modules/@vue/language-server"

            lspconfig.ts_ls.setup {
              init_options = {
                plugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" },
                  },
                },
              },
            }
          end,

          -- vuejs
          volar = function()
            lspconfig.volar.setup {
              init_options = {
                vue = {
                  hybridMode = false,
                },
              },
            }
          end,

          -- nix
          nil_ls = function()
            lspconfig.nil_ls.setup {
              settings = {
                ["nil"] = {
                  formatting = {
                    command = { "alejandra" }
                  }
                }
              }
            }
          end

        }
      })
    end
  },
  { -- code action preview
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("tiny-code-action").setup()
    end
  },
  { -- show which key is what
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  { -- tabline
    "akinsho/bufferline.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { -- handle vim tabs with buffers
        "tiagovla/scope.nvim",
        config = function()
          require("scope").setup()
        end
      },
    },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup {
        options = {
          separator_style = "thick",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          custom_filter = function(buf_number, buf_numbers)
            -- dont show quickfix buffers in the bufferline
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
          end,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local codicons = require("codicons")

            local icon = level:match("error") and codicons.get("error") or codicons.get("warning")
            return " " .. count .. icon
          end,
        }
      }
    end
  },
  { -- highlight selected words
    "rrethy/vim-illuminate"
  },
  { -- git diff view / conflict
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("diffview").setup {
        view = {
          merge_tool = {
            layout = "diff4_mixed",
          },
        },
        file_panel = {
          win_config = {
            type = "split",
            position = "right",
            win_opts = {},
          },
        },
      }
    end,
    keys = {
      {
        "<leader>gdo",
        function()
          require("tiny-inline-diagnostic").disable();
          vim.cmd("DiffviewOpen");
        end,
        desc = "Git diff open"
      },
      {
        "<leader>gdc",
        function()
          require("tiny-inline-diagnostic").enable();
          vim.cmd("DiffviewClose");
        end,
        desc = "Git diff close"
      },
      {
        "<leader>glb", ":DiffviewFileHistory<CR>", desc = "Show branch history"
      },
      {
        "<leader>glf", ":DiffviewFileHistory %<CR>", desc = "Show file history"
      },
    },
  },
  { -- telescope ui selector
    "nvim-telescope/telescope-ui-select.nvim"
  },
  { -- color selector
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        highlighter = {
          auto_enable = true,
          max_byte = 500 * 1024, -- 500 KB
        },
      }
    end
  },
  {
    "vidocqh/data-viewer.nvim",
    opts = {
      autoDisplayWhenOpenFile = true,
      view = {
        float = false,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua"
    }
  },
  { -- keep casing in substitutions
    -- Visual mode :'<,'>%SubstituteCase/aaa/bbb/g
    -- Normal mode :%SubstituteCase/aaa/bbb/g
    "vim-scripts/keepcase.vim"
  },
  {
    --- keep casing in substitutions
    -- Visual mode :'<,'>%Subvert/aaa/bbb/g
    -- Normal mode :%Subvert/aaa/bbb/g
    "tpope/vim-abolish"
  },
  { -- system clipboard with ssh support, highlights copied text
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({
        highlight = {
          timeout = 420,
        }
      })
    end
  },
  { -- UI replacement
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        lsp_doc_border = true, -- nice border when hovering
      },
      messages = {
        view_search = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        config = function()
          require("notify").setup {
            fps = 60,
            stages = "slide",
            timeout = 2000,
          }
        end
      }
    }
  },
  { -- surround
    "tpope/vim-surround"
  },
  { -- programming dictionary
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.o.spelllang = vim.o.spelllang .. ",programming"
    end,
  },
  { -- distraction free
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        wezterm = true,
      },
      on_open = function()
        vim.o.cmdheight = 1
      end,
      on_close = function()
        vim.o.cmdheight = 0
      end,
    }
  },
  { -- markdown preview
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  { -- markdown preview
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      preview = {
        icon_provider = "devicons",
      },
    },
  },
  { -- search and replace tool,
    -- :Spectre
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },
  { -- diagnostics inline
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
      vim.opt.updatetime = 100
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
    end
  },
  { -- see neovim tabs in telescope
    "LukasPietzschmann/telescope-tabs",
    config = function()
      require("telescope").load_extension "telescope-tabs"
      require("telescope-tabs").setup {}
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  { -- rust crates helper
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
    end,
  },
  { -- highlight search
    "kevinhwang91/nvim-hlslens",
    lazy = false,
    config = function()
      require("hlslens").setup()
    end,
    keys = {
      {
        "n", -- resume word highlight, next occurrence
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Highlight next word",
        noremap = true,
        silent = true
      },
      {
        "N", -- resume word highlight, previous occurrence
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Highlight previous word",
        noremap = true,
        silent = true
      },
      {
        "*", -- for next occurrence of word
        [[*<Cmd>lua require('hlslens').start()<CR>]],
        desc = "Highlight next word",
        noremap = true,
        silent = true
      },
      {
        "#", -- for previous occurrence of word
        [[#<Cmd>lua require('hlslens').start()<CR>]],
        desc = "Highlight previous word",
        noremap = true,
        silent = true
      },
    },
  },
  { -- json tools
    "VPavliashvili/json-nvim",
    ft = "json",
    keys = {
      { "<leader>jff", "<cmd>JsonFormatFile<CR>", desc = "Json Format File" },
      { "<leader>jmf", "<cmd>JsonMinifyFile<CR>", desc = "Json Minify File" },
    },
  },
})

-- update time for git status in files
vim.opt.updatetime = 50

-- LSP key mappings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Floating diagnostic" })
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    -- enable inlay hints
    vim.lsp.inlay_hint.enable()

    local opts = { buffer = event.buf }

    -- TODO: descriptions

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.keymap.set("n", "==", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", require("tiny-code-action").code_action,
      { noremap = true, silent = true, buffer = event.buf })
  end
})

-- split, buffer, tab navigation
vim.api.nvim_set_keymap("n", "<c-Tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.api.nvim_set_keymap("n", "<S-Tab>", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })

-- TODO: map go back and forth using leader

-- file browser
vim.api.nvim_create_user_command("Files", ":NvimTreeFindFileToggle", {})

-- project tree
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  view = {
    width = 50,
    side = "right"
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
})

-- indent lines
local indent_char = "▏"
require("mini.indentscope").setup({
  draw = {
    delay = 10,
  },
  symbol = indent_char,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Disable indentscope for certain filetypes",
  callback = function()
    local ignore_filetypes = {
      "help",
      "lazy",
      "mason",
      "NvimTree",
      "Trouble"
    }
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.miniindentscope_disable = true
    end
  end,
})

-- telescope
require("telescope").setup {
  -- thanks to https://github.com/nvim-telescope/telescope.nvim/issues/848#issuecomment-1584291014
  defaults = vim.tbl_extend(
    "force",
    require("telescope.themes").get_ivy(),
    {
      --- your own `default` options go here, e.g.:
      sorting_strategy = "descending",
    }
  ),

  pickers = {
    find_files = {
      hidden = true
    }
  }
}
-- telescope extensions
require("telescope").load_extension "ui-select"
require("telescope").load_extension "notify"
require("telescope").load_extension "scope"
require("telescope").load_extension "live_grep_args"

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", require("telescope").extensions.live_grep_args.live_grep_args, { desc = "Find Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find opened buffers" })
vim.keymap.set("n", "<leader>ft", require("telescope-tabs").list_tabs, { desc = "Find tabs" })
vim.keymap.set("n", "<leader>fo", require("telescope").extensions.scope.buffers, { desc = "Find buffers in tab" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string" })
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Find LSP symbols in workspace" })
vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify, { desc = "Find past notifications" })

-- TODO: keep telescope for diagnostics, but disable search
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })

-- taken from https://github.com/sindrets/diffview.nvim/issues/433#issuecomment-1898322005
local winbar_git_merge = function()
  local view = require("diffview.lib").get_current_view()
  local bufnr = vim.api.nvim_get_current_buf()
  local rev_label = ""
  for _, file in ipairs(view.cur_entry and view.cur_entry.layout:files() or {}) do
    if file:is_valid() and file.bufnr == bufnr then
      local rev = file.rev
      if rev.type == 1 then
        rev_label = "LOCAL"
      elseif rev.type == 2 then
        local head = vim.trim(vim.fn.system(
          { "git", "rev-parse", "--revs-only", "HEAD" }))
        if head == rev.commit then
          rev_label = "HEAD"
        else
          rev_label = string.format("%s", rev.commit:sub(1, 7))
        end
      elseif rev.type == 3 then
        rev_label = ({
          [0] = "INDEX",
          [1] = "BASE (COMMON ANCESTOR)",
          [2] = "LOCAL (OURS)",
          [3] = "REMOTE (THEIRS)",
        })[rev.stage] or ""
      end
    end
  end
  return rev_label
end

-- status line
require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "catppuccin",
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "filename", path = 3, shorting_target = 80, } },
    lualine_c = { "branch", "diff" },
    lualine_x = {
      {
        "diagnostics",
        sources = {
          "nvim_lsp",
          "nvim_diagnostic",
          "nvim_workspace_diagnostic",
        },
      }
    },
    lualine_y = { "filetype", "encoding", "fileformat" },
    lualine_z = { "progress", "location" },
  },
  tabline = {},
  winbar = {
    lualine_a = { winbar_git_merge },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { winbar_git_merge },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "trouble", "symbols-outline", "nvim-tree", "fzf", "fugitive", "mason", "lazy", "quickfix" }
}
vim.o.laststatus = 3 -- removes the nvim statusbar since we are using lualine

-- neovide
if vim.g.neovide then
  function GetOS()
    -- source: https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
    local osname

    -- unix systems
    local fh = assert(io.popen("uname -o 2>/dev/null", "r"))
    if fh then
      osname = fh:read()
    end

    return osname or "Windows"
  end

  -- set font size
  local font_sizes = {
    ["GNU/Linux"] = 11,
    ["Darwin"] = 13,
    ["Windows"] = 10,
  }
  local font_size = font_sizes[GetOS()]
  vim.o.guifont = "JetBrains Mono:h" .. font_size

  -- set default directory
  if GetOS() == "Windows" then
    vim.cmd("cd $USERPROFILE")
  else
    vim.cmd("cd $HOME")
  end

  -- cursor
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.g.neovide_cursor_animation_length = 0.05

  -- Paste from system clipboard
  vim.api.nvim_create_user_command("Paste", function()
    vim.cmd.normal('"*p')
  end, {})
end
