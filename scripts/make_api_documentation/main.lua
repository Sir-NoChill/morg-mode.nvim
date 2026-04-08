--- Auto-generate API documentation for morg-mode.nvim.

local vimdoc = require("mega.vimdoc")

---@return string # Get the directory on-disk where this Lua file is running from.
local function _get_script_directory()
    local path = debug.getinfo(1, "S").source:sub(2)
    return path:match("(.*/)")
end

local function main()
    local current_directory = _get_script_directory()
    local root = vim.fs.normalize(vim.fs.joinpath(current_directory, "..", ".."))

    vimdoc.make_documentation_files({
        {
            source = vim.fs.joinpath(root, "lua", "morg", "init.lua"),
            destination = vim.fs.joinpath(root, "doc", "morg_api.txt"),
        },
    }, { enable_module_in_signature = false })
end

main()
