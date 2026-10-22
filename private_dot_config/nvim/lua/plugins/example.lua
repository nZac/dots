-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then
  return {
    {
      "tpope/vim-fugitive",
      -- Optional: Lazy load on specific Git commands
      -- cmd = { "Git", "G", "Gstatus", "Gdiff", "Gblame" },
      config = function()
        -- Optional: Set keymaps
        vim.keymap.set("n", "<leader>gs", "<cmd>G<cr>", { desc = "Git Status" })
        vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git Diff" })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gblame<cr>", { desc = "Git Blame" })
      end
    },
    {
      "swaits/zellij-nav.nvim",
      lazy = true,
      event = "VeryLazy",
      keys = function()
        -- Direction-aware replacement for zellij-nav's commands. `wincmd h/l` from a
        -- floating window (e.g. the Snacks explorer list) jumps back to the editor
        -- instead of moving by direction, so resolve floats to the split they sit on.
        local function nav(dir, action, zdir)
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          while cfg.relative == "win" and cfg.win do
            win = cfg.win
            cfg = vim.api.nvim_win_get_config(win)
          end
          if cfg.relative ~= "" then
            -- free-floating window (lazy, noice, ...): leave it to Zellij
            win = nil
          end
          local target = win and vim.api.nvim_win_call(win, function()
            local nr = vim.fn.winnr(dir)
            return nr ~= vim.fn.winnr() and vim.fn.win_getid(nr) or nil
          end)
          if target then
            vim.api.nvim_set_current_win(target)
            return
          end
          local res = vim.system({ "zellij", "action", action, zdir }):wait()
          if res.code ~= 0 then
            vim.notify("zellij action failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
          end
        end
        return {
          { "<c-h>", function() nav("h", "move-focus-or-tab", "left") end, desc = "navigate left or tab" },
          { "<c-j>", function() nav("j", "move-focus", "down") end, desc = "navigate down" },
          { "<c-k>", function() nav("k", "move-focus", "up") end, desc = "navigate up" },
          { "<c-l>", function() nav("l", "move-focus-or-tab", "right") end, desc = "navigate right or tab" },
        }
      end,
      opts = {},
    },
    {
      "WillEhrendreich/datastar.nvim",
      ft = { "html" }, -- add "templ" if using the Templ Go templating language: ft = { "html", "templ" }
      opts = {},
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
      },
      opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
    }
  }
end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
