{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # System tools that Neovim plugins need
    extraPackages = with pkgs; [
      # LSP servers (language intelligence)
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages."@tailwindcss/language-server"
      nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      pyright
      rust-analyzer
      gopls
      
      # Formatters (code formatting)
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      black
      rustfmt
      
      # Tools (searching, file operations, etc.)
      ripgrep      # Fast search (Telescope uses this)
      fd           # Fast find (Telescope uses this)
      nodejs_20    # Node.js runtime
      tree-sitter  # Syntax highlighting
      lazygit      # Git TUI
      shellcheck   # Shell script linting
      shfmt        # Shell script formatting
    ];
    
    # Bootstrap code that runs immediately
    extraLuaConfig = ''
      -- Bootstrap lazy.nvim (download if not present)
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git", "clone", "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)
      
      -- Set leader keys BEFORE loading lazy
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      
      -- Setup LazyVim
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          
          -- Language support
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.lang.rust" },
          { import = "lazyvim.plugins.extras.lang.python" },
          { import = "lazyvim.plugins.extras.lang.go" },
          
          -- Tools
          { import = "lazyvim.plugins.extras.formatting.prettier" },
          { import = "lazyvim.plugins.extras.linting.eslint" },
          { import = "lazyvim.plugins.extras.editor.mini-files" },
          
          -- Custom plugins
          { import = "plugins" },
        },
        defaults = { lazy = false, version = false },
        install = { colorscheme = { "tokyonight", "habamax" } },
        checker = { enabled = true },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
          },
        },
      })
    '';
  };
  
  # Configuration files (loaded by LazyVim)
  xdg.configFile = {
    "nvim/lua/config/options.lua".text = ''
      -- Custom options (LazyVim loads this automatically)
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"
    '';
    
    "nvim/lua/config/keymaps.lua".text = ''
      -- Custom keymaps (LazyVim loads this automatically)
      -- Add your custom keybindings here
    '';
    
    "nvim/lua/config/autocmds.lua".text = ''
      -- Custom autocommands (LazyVim loads this automatically)
      -- Add your custom autocommands here
    '';
    
    # Custom plugins
    "nvim/lua/plugins/copilot.lua".text = ''
      return {
        -- GitHub Copilot
        {
          "zbirenbaum/copilot.lua",
          cmd = "Copilot",
          event = "InsertEnter",
          config = function()
            require("copilot").setup({
              suggestion = {
                enabled = true,
                -- Disable automatic inline suggestions; keep manual accept via keymap
                auto_trigger = false,
                debounce = 75,
                keymap = {
                  accept = "<C-l>",
                  accept_word = false,
                  accept_line = false,
                  next = "<C-]>",
                  prev = "<C-[>",
                  dismiss = "<C-h>",
                },
              },
              filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                ["."] = false,
              },
            })
          end,
        },
        
        -- Copilot Chat
        {
          "CopilotC-Nvim/CopilotChat.nvim",
          branch = "canary",
          dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
          },
          opts = {
            debug = false,
            show_help = "yes",
          },
          keys = {
            { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Copilot Chat" },
            { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain" },
            { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix" },
            { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Copilot Tests" },
          },
        },
      }
    '';
    
    "nvim/lua/plugins/colorscheme.lua".text = ''
      return {
        {
          "folke/tokyonight.nvim",
          opts = {
            style = "night",
            transparent = false,
          },
        },
      }
    '';
  };
}