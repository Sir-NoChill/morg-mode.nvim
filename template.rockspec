local git_ref = "$git_ref"
local modrev = "$modrev"
local specrev = "$specrev"

local repo_url = "$repo_url"

rockspec_format = "3.0"
package = "morg-mode.nvim"
version = modrev .. "-" .. specrev

local user = "Sir-NoChill"

description = {
    homepage = "https://github.com/" .. user .. "/" .. package,
    labels = { "neovim", "neovim-plugin", "org-mode", "markdown", "productivity" },
    license = "MIT",
    summary = "Neovim integration for morg-mode — a markdown-idiomatic org-mode replacement",
}

dependencies = {
    "lua >= 5.1, < 6.0",
}

test_dependencies = {
    "busted >= 2.0, < 3.0",
    "nlua",
}

test = { type = "busted" }

source = {
    url = repo_url .. "/archive/" .. git_ref .. ".zip",
    dir = "$repo_name-" .. "$archive_dir_suffix",
}

if modrev == "scm" or modrev == "dev" then
    source = {
        url = repo_url:gsub("https", "git"),
    }
end

build = {
    type = "builtin",
    copy_directories = $copy_directories,
}
