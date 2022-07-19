_G.__luacache_config = {
	chunks = {
		enable = true,
		path = vim.fn.stdpath("cache") .. "/luacache_chunks",
	},
	modpaths = {
		enable = true,
		path = vim.fn.stdpath("cache") .. "/luacache_modpaths",
	},
}
require("impatient")

require("packer").startup(function()
	use("L3MON4D3/LuaSnip")
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-path")
	use("hrsh7th/nvim-cmp")
	use("jose-elias-alvarez/null-ls.nvim")
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("junegunn/fzf.vim")
	use("kosayoda/nvim-lightbulb")
	use("kyazdani42/nvim-tree.lua")
	use("kyazdani42/nvim-web-devicons")
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	})
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/cmp-rg")
	use({ "kamykn/spelunker.vim", opt = true, event = "WinEnter" })
	use({ "kamykn/popup-menu.nvim", opt = true, event = "WinEnter" })
	use("lukas-reineke/indent-blankline.nvim")
	use("neoclide/jsonc.vim")
	use("neovim/nvim-lspconfig")
	use("norcalli/nvim-colorizer.lua")
	use("ntpeters/vim-better-whitespace")
	use("nvim-lualine/lualine.nvim")
	use("nvim-treesitter/nvim-treesitter-refactor")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("onsails/lspkind-nvim")
	use("rafamadriz/friendly-snippets")
	use("ray-x/go.nvim")
	use("ray-x/guihua.nvim")
	use("daschw/leaf.nvim")
	use("saadparwaiz1/cmp_luasnip")
	use("tpope/vim-abolish")
	use("tpope/vim-commentary")
	use("tpope/vim-fugitive")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("wbthomason/packer.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-github.nvim" } },
	})
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "ray-x/lsp_signature.nvim" })
end)

require("telescope").setup({
	defaults = {
		prompt_prefix = "> ",
		selection_caret = "> ",
		entry_prefix = "  ",
		multi_icon = "<>",

		-- path_display = "truncate",

		winblend = 0,

		layout_strategy = "horizontal",
		layout_config = {
			width = 0.95,
			height = 0.85,
			prompt_position = "bottom",

			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},

			vertical = {
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},

			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},

		selection_strategy = "reset",
		sorting_strategy = "descending",
		scroll_strategy = "cycle",
		color_devicons = true,
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("gh")

function find_files_all()
	require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end

require("lualine").setup({ options = { theme = "leaf" } })

require("colorizer").setup({ "*" })

require("nvim-tree").setup({
	update_focused_file = { enable = true },
	view = { width = 50, side = "right" },
	git = {
		enable = true,
		ignore = false,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	renderer = {
		highlight_opened_files = "all",
	},
})

local cmp = require("cmp")
local winhighlight = {
	winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
}

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item({
			behavior = cmp.SelectBehavior.Select,
		}),
		["<S-Tab>"] = cmp.mapping.select_prev_item({
			behavior = cmp.SelectBehavior.Select,
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "rg", keyword_length = 3 },
		{ name = "path", keyword_length = 5 },
	},
	formatting = {
		format = require("lspkind").cmp_format({
			with_text = false,
			maxwidth = 50,
		}),
	},
	experimental = { native_menu = false },
	window = {
		completion = cmp.config.window.bordered(winhighlight),
		documentation = cmp.config.window.bordered(winhighlight),
	},
})

require("lsp_signature").setup({})

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = {
		enable = true,
		custom_captures = {
			-- Highlight the @foo.bar capture group with the "Identifier" highlight group.
			["foo.bar"] = "Identifier",
		},
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = enable,
		keymaps = {
			-- mappings for incremental selection (visual mappings)
			init_selection = "gnn", -- maps in normal mode to init the node/scope selection
			node_incremental = "grn", -- increment to the upper named parent
			scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
			node_decremental = "grm", -- decrement to the previous node
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
	},
	context_commentstring = { enable = true, enable_autocmd = false },
})

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#3a3a3a gui=nocombine]])

require("indent_blankline").setup({
	char_highlight_list = {
		"IndentBlanklineIndent1",
	},
})

require("go").setup()

require("todo-comments").setup({})

vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])

require("leaf").setup({
	undercurl = true,
	commentStyle = "italic",
	functionStyle = "NONE",
	keywordStyle = "italic",
	statementStyle = "bold",
	typeStyle = "NONE",
	variablebuiltinStyle = "italic",
	transparent = true,
	colors = {},
	overrides = {},
	theme = "darkest", -- default, alternatives: "dark", "lighter", "darker", "lightest", "darkest"
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.cmd("colorscheme leaf")
