local function file_exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

local function build_blink(path)
  vim.notify("Building blink.cmp...", vim.log.levels.INFO)
  vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
    if obj.code == 0 then
      vim.schedule(function() vim.notify("blink.cmp built successfully", vim.log.levels.INFO) end)
    else
      vim.schedule(function() vim.notify("blink.cmp build failed", vim.log.levels.ERROR) end)
    end
  end)
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("BlinkBuildHook", { clear = true }),
  callback = function(args)
    if args.data.spec.name == "blink.cmp" then
      if args.data.kind == "update" or args.data.kind == "install" then
        build_blink(args.data.path)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("TreesitterPackUpdate", { clear = true }),
  callback = function(args)
    if args.data and args.data.spec and args.data.spec.name == "nvim-treesitter" then
      if args.data.kind == "update" or args.data.kind == "install" then
        vim.cmd("TSUpdate")
      end
    end
  end,
})

