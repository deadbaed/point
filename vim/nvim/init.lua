-- leader keys
vim.g.mapleader = " " -- "space"
vim.g.maplocalleader = ","

-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- auto resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- show which line cursor is on
vim.opt.cursorline = true

-- colors
local current_colorscheme = "catppuccin"
vim.o.background = "light" -- :h background

-- border for floating windows
vim.o.winborder = "single"

-- always have signcolumn
vim.opt.signcolumn = "yes"

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

-- highlight search, and clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- the icons i like
local my_icons = {
  error = "",
  warning = "",
  hint = "",
  info = "",
}

-- git merge tool: dipslay which file is which during a conflict
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

-- package manager
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
require("lazy").setup({
  spec = {
    { -- colorscheme
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme(current_colorscheme)
      end
    },
    { -- icons
      "nvim-tree/nvim-web-devicons"
    },
    { -- which key does what
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        preset = "helix",
      },
      keys = {
        {
          "<leader>?",
          function() require("which-key").show({ global = false }) end,
          desc = "Buffer Local Keymaps (which-key)",
        },
        {
          "<leader>!",
          function() require("which-key").show({ global = true }) end,
          desc = "Global Keymaps (which-key)",
        },
      },
    },
    { -- syntax highlight
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function ()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          auto_install = true,
          ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline", "editorconfig", "regex" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },
    { -- syntax context
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
      end,
    },
    { -- centered cmdline
      "folke/noice.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      event = "VeryLazy",
      opts = {
        lsp = {
          progress = { enabled = false },
          hover = { enabled = false },
          signature = { enabled = false },
          message = { enabled = false },
        },
        presets = {
          inc_rename = true, -- input dialog for inc-rename.nvim
        },
      },
    },
    { -- visual feedback when renaming with lsp
      "smjonas/inc-rename.nvim",
      opts = {},
      init = function ()
        vim.o.inccommand = "split" -- show the effects of substitutions in preview window
      end
    },
    { -- some QOL plugins
      "folke/snacks.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        explorer = {
          replace_netrw = true,
        },
        picker = {
          layout = "ivy",
        },
        statuscolumn = { enabled = true },
        terminal = {},
      },
      keys = {
        { "<leader><space>", function() require"snacks".picker.smart() end, desc = "Smart Find" },
        { "<leader>e", function() require"snacks".explorer() end, desc = "File Explorer" },
        { "<leader>ff", function() require"snacks".picker.files({ cmd = "fd", hidden = true, ignored = true }) end, desc = "Find Files" },
        { "<leader>fg", function() require"snacks".picker.grep({ cmd = "rg" }) end, desc = "Grep" },
        { "<leader>fs", function() require"snacks".picker.grep_word({ cmd = "rg" }) end, desc = "Grep selected word" },
        { "<leader>fh", function() require"snacks".picker.help() end, desc = "Find Help" },
        { "<leader>fd", function() require"snacks".picker.diagnostics({ focus = "list" }) end, desc = "Diagnostics in file" },
        { "<leader>fu", function() require"snacks".picker.undo() end, desc = "Find Undo" },
        { "<leader>bd", function() require"snacks".bufdelete() end, desc = "Buffer Delete" },
        { "<leader>n", function() require"snacks".picker.notifications() end, desc = "Notification History" },
        { "<leader>u", function() require"snacks".picker.undo() end, desc = "Undo History" },
        { "<leader>:", function() require"snacks".picker.command_history() end, desc = "Command History" },
        { "<leader>,", function() require"snacks".picker.buffers({ layout = { preset = "vscode" } }) end, desc = "Find Opened buffers" },
        { "<leader>gll", function() require"snacks".picker.git_log() end, desc = "Git Log" },
        { "<leader>gs", function() require"snacks".picker.git_status() end, desc = "Git Status" },
        { "<leader>gdd", function() require"snacks".picker.git_diff() end, desc = "Git Diff" },
      },
    },
    { -- scoped buffers
      "tiagovla/scope.nvim",
      config = true,
    },
    { -- statusline, bufferline, tabline
      "nvim-lualine/lualine.nvim",
      init = function()
        vim.o.laststatus = 3 -- have one single status bar
      end,
      dependencies = {
        {  -- get status of lsp
          "linrongbin16/lsp-progress.nvim",
          opts = {
            decay = 1500,
            spin_update_time = 50,
            spinner = {
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
          },
        },
        "tiagovla/scope.nvim",
      },
      opts = {
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode", "searchcount" },
          lualine_b = { "branch", "diff", {
            "diagnostics",
            icons_enabled = false,
            sources = {
              "nvim_lsp",
              "nvim_diagnostic",
              "nvim_workspace_diagnostic",
            },
          }},
          lualine_c = { { "filename", path = 0, newfile_status = false, } },
          lualine_x = {
            { function() return require("lsp-progress").progress() end },
          },
          lualine_y = {
            "filetype",
            { "encoding", show_bomb = true },
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            }
          },
          lualine_z = { "progress", "location", "selectioncount" },
        },
        tabline = {
          lualine_a = {},
          lualine_b = { { "filename", path = 2 } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { "buffers" },
          lualine_z = { "tabs" },
        },
        winbar = {
          lualine_a = { winbar_git_merge },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = { winbar_git_merge },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "oil", "man",  "fugitive", "mason", "lazy", "quickfix" }
      },
    },
    { -- netrw replacement
      "stevearc/oil.nvim",
      lazy = false,
      opts = {
        view_options = {
          show_hidden = true,
        },
      },
      init = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end
    },
    { -- clipboard
      "ibhagwan/smartyank.nvim",
      opts = {
        highlight = {
          timeout = 500,
        }
      },
    },
    { -- list of todos
      "folke/todo-comments.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/snacks.nvim",
      },
      config = true,
      keys = {
        { "<leader>ft", function() require"snacks".picker.todo_comments() end, desc = "Find TODOs" },
        { "]t", function() require"todo-comments".jump_next() end, desc = "Next TODO" },
        { "[t", function() require"todo-comments".jump_prev() end, desc = "Previous TODO" },
      },
    },
    { -- lsp installer
      "williamboman/mason.nvim",
      opts = {},
    },
    { -- lsp config with lsp installer
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "b0o/schemastore.nvim", -- JSON schema helper
      },
      opts = {
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "taplo",
          "bashls",
          "jsonls",
          "html",
        },
        automatic_installation = true,
        handlers = {
          -- Default setup for all LSP servers
          function(server_name)
            vim.lsp.enable(server_name)
          end,

          -- rust
          ["rust_analyzer"] = function()
            vim.lsp.config("rust_analyzer", {
              settings = {
                ["rust-analyzer"] = {
                  check = {
                    command = "clippy"
                  },
                  cargo = {
                    buildScripts = {
                      enable = true,
                    },
                    -- features = "all",
                  },
                  procMacro = {
                    enable = true
                  },
                }
              }
            })
            vim.lsp.enable("rust_analyzer")
          end,

          -- json
          ["jsonls"] = function()
            vim.lsp.config("jsonls", {
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
            vim.lsp.enable("jsonls")
          end,

          -- lua
          ["lua_ls"] = function()
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
            vim.lsp.config("lua_ls", lua_opts)
            vim.lsp.enable("lua_ls")
          end,

          -- tailwind
          ["tailwindcss"] = function ()
            vim.lsp.config("tailwindcss", {
              settings = {
                includeLanguages = {
                  rust = "html",
                },
              },
              filetypes = {
                "rust",
              },
            })
            vim.lsp.enable("tailwindcss")
          end,

          -- typescript
          -- for .ts and .js files, use ts_ls
          -- for .vue files, use volar
          ["ts_ls"] = function()
            local mason_registry = require("mason-registry")
            local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() ..
            "/node_modules/@vue/language-server"

            vim.lsp.config("ts_ls", {
              init_options = {
                plugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" },
                  },
                },
              },
            })
            vim.lsp.enable("ts_ls")
          end,

          -- vuejs
          ["volar"] = function()
            vim.lsp.config("volar", {
              init_options = {
                vue = {
                  hybridMode = false,
                },
              },
            })
            vim.lsp.enable("volar")
          end,

          -- nix
          ["nil_ls"] = function()
            vim.lsp.config("nil_ls", {
              settings = {
                ["nil"] = {
                  formatting = {
                    command = { "alejandra" }
                  }
                }
              }
            })
            vim.lsp.enable("nil_ls")
          end,
        },
      },
    },
    { -- preview for code actions
      "rachartier/tiny-code-action.nvim",
      dependencies = {
        {"nvim-lua/plenary.nvim"},
        {"folke/snacks.nvim"},
      },
      event = "LspAttach",
      opts = {
        picker = {
          "snacks",
          opts = {
            focus = "list",
          },
        }
      },
      keys = {
        { "gra", function () require("tiny-code-action").code_action() end, desc = "Go, Run (Code) Action", noremap = true, silent = true },
      },
    },
    { -- autocomplete
      "saghen/blink.cmp",
      dependencies = {
        "onsails/lspkind.nvim", -- pictograms
        "nvim-tree/nvim-web-devicons", -- icons
        "rafamadriz/friendly-snippets", -- snippets
        "moyiz/blink-emoji.nvim", -- emoji
      },
      version = "1.*", -- use a release tag to download pre-built binaries
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',
      ---@module "blink.cmp"
      ---@type blink.cmp.Config
      opts = {
        -- "default" (recommended) for mappings similar to built-in completions (C-y to accept)
        -- "super-tab" for mappings similar to vscode (tab to accept)
        -- "enter" for enter to accept
        -- "none" for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "enter" },

        appearance = {
          -- "mono" (default) for "Nerd Font Mono" or "normal" for "Nerd Font"
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono"
        },

        signature = {
          enabled = true,
        },

        completion = {
          -- (Default) Only show the documentation popup when manually triggered
          documentation = {
            auto_show = false,
          },

          -- Pretty menu with lspkind
          menu = {
            draw = {
              columns = {
                { "kind_icon", "kind", gap = 1 },
                { "label", "label_description", gap = 1 },
                { "source_name" },
              },
              components = {
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        icon = dev_icon
                      end
                    else
                      icon = require("lspkind").symbolic(ctx.kind, {
                        mode = "symbol",
                        preset = "codicons",
                      })
                    end

                    return icon .. ctx.icon_gap
                  end,

                  -- Optionally, use the highlight groups from nvim-web-devicons
                  -- You can also add the same function for `kind.highlight` if you want to
                  -- keep the highlight groups in sync with the icons.
                  highlight = function(ctx)
                    local hl = ctx.kind_hl
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        hl = dev_hl
                      end
                    end
                    return hl
                  end,
                }
              },
            }
          },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "emoji" },
          providers = {
            emoji = {
              module = "blink-emoji",
              name = "Emoji",
              score_offset = 15, -- Tune by preference
              min_keyword_length = 2,
              opts = { insert = true }, -- Insert emoji (default) or complete its name
            }
          },
        },
        fuzzy = { implementation = "prefer_rust_with_warning",
          sorts = {
            'exact', -- exacts matches will always be first
            -- defaults
            'score',
            'sort_text',
          },
        }
      },
      opts_extend = { "sources.default" }
    },
    -- TODO: dap + dap ui
    -- TODO: neotest (see rubycat's)
    -- TODO: overseerr.nvim
    { -- git commit
      "rhysd/committia.vim"
    },
    { -- git status in files
      "lewis6991/gitsigns.nvim",
      opts = {
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
          map("n", "<leader>hpp", gitsigns.preview_hunk, { desc = "Hunk Preview" })
          map("n", "<leader>hpi", gitsigns.preview_hunk_inline, { desc = "Hunk Preview Inline" })
          map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "Hunk Blame" })
          map("n", "]h", function() gitsigns.nav_hunk("next") end, { desc = "Next Hunk" })
          map("n", "[h", function() gitsigns.nav_hunk("prev") end, { desc = "Previous Hunk" })
        end
      },
    },
    { -- git diff view / conflict / merge tool
      "sindrets/diffview.nvim",
      opts = {
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
      },
      keys = {
        { "<leader>gdo", ":DiffviewOpen<CR>", desc = "Git Diff Open" },
        { "<leader>gdc", ":DiffviewClose<CR>", desc = "Git Diff Close" },
        { "<leader>glb", ":DiffviewFileHistory<CR>", desc = "Git Log Branch" },
        { "<leader>glf", ":DiffviewFileHistory %<CR>", desc = "Git Log File" },
      },
    },
    { -- virtual indentation helper
      "shellRaining/hlchunk.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        chunk = {
          enable = true,
          chars = {
            right_arrow = "─",
          },
          delay = 10,
        },
      },
    },
    { -- highlight selected words
      "rrethy/vim-illuminate"
    },
    { -- color picker
      "uga-rosa/ccc.nvim",
      opts = {
        highlighter = {
          auto_enable = true,
          lsp = true,
        }
      },
      init = function()
        vim.opt.termguicolors = true
      end,
    },
    {
      -- keep casing in substitutions
      --
      -- :%s/facility/building/g
      -- :%s/Facility/Building/g
      -- :%s/FACILITY/BUILDING/g
      -- :%s/facilities/buildings/g
      -- :%s/Facilities/Buildings/g
      -- :%s/FACILITIES/BUILDINGS/g
      --
      -- :%Subvert/facilit{y,ies}/building{,s}/g
      --
      --
      -- Normal mode :%Subvert/aaa/bbb/g
      -- Visual mode :'<,'>%Subvert/aaa/bbb/g
      "tpope/vim-abolish"
    },
    { -- search and replace tool
      -- :Spectre
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    { -- automatically open/close braces
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        check_ts = true, -- use treesitter
      },
    },
    { -- todo.txt support
      "freitass/todo.txt-vim"
    },
    { -- markdown preview
      "OXY2DEV/markview.nvim",
      lazy = false,
    },
    { -- rust crates helper
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      },
    },
  },
  install = { colorscheme = { current_colorscheme } },
  checker = { enabled = true, notify = false },
})

-- key mappings
vim.keymap.set("n", "<leader>jm", ":%!jq -c<CR>", { desc = "Json Minify buffer" })
vim.keymap.set("n", "<leader>ju", ":%!jq<CR>", { desc = "Json Uglify buffer" })
vim.keymap.set("v", "<leader>jm", ":'<,'>!jq -c<CR>", { desc = "Json Minify selection" })
vim.keymap.set("v", "<leader>ju", ":'<,'>!jq<CR>", { desc = "Json Uglify selection" })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "Buffer new" })
vim.keymap.set("n", "<leader><tab><tab>", ":tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>d", ":tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "]<tab>", ":tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "[<tab>", ":tabprevious<cr>", { desc = "Previous Tab" })

-- diagnostics
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = my_icons.error,
      [vim.diagnostic.severity.WARN] = my_icons.warning,
      [vim.diagnostic.severity.INFO] = my_icons.info,
      [vim.diagnostic.severity.HINT] = my_icons.lightbulb,
    },
  },
})

-- lsp startup
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- inlay hint
    if client ~= nil and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
    end

    -- key mappings
    vim.keymap.set("n", "gd", function () require"snacks".picker.lsp_definitions({ focus = "list" }) end, { desc = "Goto Definition", buffer = args.buf })
    vim.keymap.set("n", "grr", function () require"snacks".picker.lsp_references({ focus = "list" }) end, { desc = "Goto References", buffer = args.buf })
    vim.keymap.set("n", "gri", function () require"snacks".picker.lsp_implementations({ focus = "list" }) end, { desc = "Goto Implementations", buffer = args.buf })
    vim.keymap.set("n", "grn", ":IncRename ", { desc = "Go ReName", buffer = args.buf })
    vim.keymap.set("n", "gl", function () vim.diagnostic.open_float() end, { desc = "Diagnostics in Floating window" })
    vim.keymap.set("n", "<leader>l", function() require"snacks".picker.lsp_symbols() end, { desc = "LSP symbols in file", buffer = args.buf })
    vim.keymap.set("n", "<leader>fw", function() require"snacks".picker.lsp_workspace_symbols() end, { desc = "Find LSP symbols in workspace", buffer = args.buf })
    vim.keymap.set("n", "==", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file", buffer = args.buf })
  end,
})

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})

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
