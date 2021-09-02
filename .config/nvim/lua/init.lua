require 'go'.setup({
  goimport = 'gopls', -- if set to 'gopls' will use golsp format
  gofmt = 'gopls', -- if set to gopls will use golsp format
  max_line_len = 120,
  tag_transform = false,
  test_dir = '',
  comment_placeholder = '   ',
  lsp_cfg = false, -- false: use your own lspconfig
  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = true, -- use on_attach from go.nvim
  dap_debug = false,
})

local protocol = require'vim.lsp.protocol'

--require('go').setup({
  --goimport='gofumports', -- goimport command
  --gofmt = 'gofumpt', --gofmt cmd,
  --max_line_len = 120, -- max line length in goline format
  --tag_transform = false, -- tag_transfer  check gomodifytags for details
  --test_template = '', -- default to testify if not set; g:go_nvim_tests_template  check gotests for details
  --test_template_dir = '', -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
  --comment_placeholder = '' ,  -- comment_placeholder your cool placeholder e.g. ﳑ       
  --verbose = false,  -- output loginf in messages
  --lsp_cfg = false, -- true: apply go.nvim non-default gopls setup
  --lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
  --lsp_on_attach = true, -- if a on_attach function provided:  attach on_attach function to gopls
                       ---- true: will use go.nvim on_attach if true
                       ---- nil/false do nothing
  --lsp_codelens = true, -- set to false to disable codelens, true by default
  --gopls_remote_auto = true, -- add -remote=auto to gopls
  --gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile",
  --"/var/log/gopls.log" }
  --lsp_diag_hdlr = true, -- hook lsp diag handler
  --dap_debug = true, -- set to false to disable dap
  --dap_debug_keymap = true, -- set keymaps for debugger
  --dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
  --dap_debug_vt = true, -- set to true to enable dap virtual text

--})
