local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "fuadnafiz98.lsp.lsp-installer"
require("fuadnafiz98.lsp.handlers").setup()
require "fuadnafiz98.lsp.null-ls"
