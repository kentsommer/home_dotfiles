local function file_exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

-- Google
if file_exists(vim.fn.stdpath("config") .. "/lua/google.lua") then
  require("google")
end
