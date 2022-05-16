-- print("asdf")

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()

	use 'wbthomason/packer.nvim'
	--    use 'neovim/nvim-lspconfig'
	--    use 'hrsh7th/nvim-cmp'
	--      use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	--  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	--  use 'L3MON4D3/LuaSnip' -- Snippets plugin

	use 'christianchiarulli/nvcode-color-schemes.vim'
	use 'nvim-treesitter/nvim-treesitter'

	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	use 'dcampos/nvim-snippy'
	use 'dcampos/cmp-snippy'
	use 'SirVer/ultisnips'
	use 'quangnguyen30192/cmp-nvim-ultisnips'

end)


local cmp = require 'cmp'

-- Global setup.
cmp.setup({

	-- nvim-cmp will pre-select the item that the source specified.
	preselect = cmp.PreselectMode.Item,

	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'snippy' }, -- For snippy users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
	}, {
		{ name = 'buffer' },
	})
})
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})
-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig = require('lspconfig')
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver', 'sumneko_lua' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
	}
end

require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	-- ensure_installed = { "all" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing (for "all")
	-- ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}



-- require'lspconfig'.rust_analyzer.setup{}
--
-- local cmp = require 'cmp'
--
-- -- Add additional capabilities supported by nvim-cmp
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
--
-- local lspconfig = require('lspconfig')
--
-- -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver'  }
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     -- on_attach = my_custom_on_attach,
--     capabilities = capabilities,
--   }
-- end
--
-- lspconfig.clangd.setup{
--     capabilities = capabilities
-- }
--
--
-- -- luasnip setup
-- local luasnip = require 'luasnip'
--
-- -- nvim-cmp setup
-- local cmp = require 'cmp'
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   }),
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }
--

vim.opt.ruler = true
vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.scrolloff = 5 --  keep 3 lines when scrolling
vim.opt.backspace = "indent,eol,start" --  make that backspace key work the way it

vim.opt.showmatch = true --  jump to matches when entering parentheses
vim.opt.matchtime = 0 --  tenths of a second to show the matching

vim.opt.hlsearch = true --  highlight searches
vim.opt.incsearch = true --  do incremental searching
vim.opt.ignorecase = true --  ignore case when searching
vim.opt.smartcase = true --  no ignorecase if Uppercase char present

-- vim.opt.expandtab = true
-- vim.opt.smarttab = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.colorcolumn = "80"


vim.opt.cursorcolumn = true
vim.opt.cursorline = true

-- vim.colorscheme = "nvcode"

vim.cmd("colorscheme nvcode")


-- vim.opt.nowrap = true

-- vim.cmd [[
--
-- " set relativenumber
-- "
-- " set scrolloff=5                 " keep 3 lines when scrolling
-- " set backspace=indent,eol,start  " make that backspace key work the way it
-- "
-- " set showmatch                   " jump to matches when entering parentheses
-- " set matchtime=0                 " tenths of a second to show the matching
-- "
-- " set hlsearch                    " highlight searches
-- " set incsearch                   " do incremental searching
-- " set ignorecase                  " ignore case when searching
-- " set smartcase                   " no ignorecase if Uppercase char present
-- "
-- " set expandtab smarttab
-- " set autoindent smartindent shiftround
-- " set shiftwidth=4 softtabstop=4 tabstop=4
-- " set colorcolumn=80
-- "
-- "
-- " set cursorcolumn
-- " set cursorline
-- " set nowrap
-- "
--  colorscheme nvcode
--
--  ]]
--


-- vim.keymap.set('n',',f',function() vim.lsp.buf.formatting() end)
vim.keymap.set('n', ',f', vim.lsp.buf.formatting)

vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', ',wa', vim.lsp.buf.add_workspace_folder)
vim.keymap.set('n', ',wr', vim.lsp.buf.remove_workspace_folder)
--vim.keymap.set('n', ',wl', print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.keymap.set('n', ',wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
vim.keymap.set('n', ',D', vim.lsp.buf.type_definition)
vim.keymap.set('n', ',rn', vim.lsp.buf.rename)
vim.keymap.set('n', ',ca', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
-- vim.keymap.set('n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
