local installer = require("llmcat.installer")
installer.ensure_installed()

local M = {}

-- Helper: Set terminal keymaps in the floating terminal buffer
-- to ensure keys are passed directly to the underlying process.
local function set_term_keymaps(buf)
    -- These mappings try to pass through the keys without Neovim intercepting them.
    -- You may need to adjust this list according to which keys llmcat uses.
    local term_keys = {
        ["<C-d>"]   = "<C-d>",
        ["<C-f>"]   = "<C-f>",
        ["<C-/>"]   = "<C-/>",
        ["<Tab>"]   = "<Tab>",
        ["<S-Tab>"] = "<S-Tab>",
        ["<CR>"]    = "<CR>",
        ["<Esc>"]   = "<Esc>",
    }

    for lhs, rhs in pairs(term_keys) do
        vim.api.nvim_buf_set_keymap(buf, 't', lhs, rhs, { noremap = true, silent = true })
    end
end

-- Runs llmcat inside a floating terminal window.
function M.run_floating(args)
    local cmd = "llmcat " .. args

    -- Calculate dimensions for the floating window (80% of the screen)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    }

    -- Create a new scratch buffer.
    local buf = vim.api.nvim_create_buf(false, true)
    -- Open a floating window with that buffer.
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Open a terminal in the buffer running the llmcat command.
    vim.fn.termopen(cmd)

    -- Set our custom keymaps in terminal mode.
    vim.schedule(function()
        set_term_keymaps(buf)
    end)

    -- Enter insert mode so that the terminal is interactive.
    vim.cmd("startinsert!")

    -- Set the buffer to be wiped when the window is closed.
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
end

-- Create a user command :Llmcat that opens a floating terminal window.
vim.api.nvim_create_user_command("Llmcat", function(opts)
    local args = opts.args or ""
    M.run_floating(args)
end, { nargs = "*" })

return M
