local M = {}

-- Define the destination directory and file for the downloaded llmcat binary.
local install_dir = vim.fn.stdpath("data") .. "/bin"
local install_path = install_dir .. "/llmcat"

-- URL of the raw llmcat file from GitHub (adjust branch if necessary)
local raw_url = "https://raw.githubusercontent.com/azer/llmcat/main/llmcat"

-- Function to ensure that llmcat is installed.
function M.ensure_installed()
    -- First, check if llmcat is already in PATH.
    if vim.fn.executable("llmcat") == 1 then
        return
    end

    -- Next, check if we have a locally downloaded copy.
    if vim.fn.filereadable(install_path) == 1 then
        vim.notify("Using locally downloaded llmcat from " .. install_path, vim.log.levels.INFO)
        return
    end

    vim.notify("llmcat not found. Downloading llmcat binary...", vim.log.levels.INFO)

    -- Create the installation directory if it doesn't exist.
    vim.fn.mkdir(install_dir, "p")

    -- Download the llmcat file using curl.
    local cmd = string.format("curl -fLo %s --create-dirs %s", install_path, raw_url)
    local result = os.execute(cmd)
    if result ~= 0 then
        vim.notify("Failed to download llmcat binary via curl. Please install it manually.", vim.log.levels.ERROR)
        return
    end

    -- Make the downloaded file executable.
    os.execute("chmod +x " .. install_path)
    vim.notify("llmcat downloaded and installed successfully at " .. install_path, vim.log.levels.INFO)
end

return M
