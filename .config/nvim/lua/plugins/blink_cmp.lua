return {
  {
    "saghen/blink.cmp",
    -- only if not already included by LazyVim extras
    opts = function(_, opts)
      opts.keymap = {
        preset = "none", -- start with no preset mappings
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        -- Explicitly disable others
        ["<CR>"] = false,
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
        ["<Up>"] = false,
        ["<Down>"] = false,
      }
      -- Also disable auto-preselect of first item
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        preselect = false,
        auto_insert = false,
      }
      return opts
    end,
  },
}
