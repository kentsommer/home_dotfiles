-------------
-- Options --
-------------
require("options")

-------------
-- Plugins --
-------------
require("setup_plugins")

--------
-- UI --
--------
require("ui")

--------------------------------------
-- LSP, Completion, and Diagnostics --
--------------------------------------
require("lsp")

--------------------------
-- Google Plugin Extras --
--------------------------
pcall(require, "google")
