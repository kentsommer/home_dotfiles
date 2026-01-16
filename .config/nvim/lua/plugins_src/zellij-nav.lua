local M = {}
local uv = vim.uv or vim.loop

local dir_map = {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
}

-- Pre-check if we are actually inside Zellij to avoid useless system calls
local is_zellij = os.getenv("ZELLIJ") ~= nil

local function navigate(dir)
    local current_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. dir)

    -- If window didn't change and we are in Zellij, move the pane
    if current_win == vim.api.nvim_get_current_win() and is_zellij then
        -- Spawn process directly via LibUV for maximum speed
        uv.spawn("zellij", {
            args = { "action", "move-focus", dir_map[dir] },
            detach = true
        }, function(code)
            -- Optional: handle error code if needed
        end)
    end
end

function M.setup(opts)
    opts = opts or {}
    local bindings = opts.bindings or {
        h = "<C-h>",
        j = "<C-j>",
        k = "<C-k>",
        l = "<C-l>",
    }

    for dir, keys in pairs(bindings) do
        -- Use 'nowait' and 'silent' to reduce perceived lag
        vim.keymap.set("n", keys, function() navigate(dir) end, { 
            desc = "Move focus " .. dir_map[dir],
            silent = true,
            nowait = true 
        })
    end
end

return M
