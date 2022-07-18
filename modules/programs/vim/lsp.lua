local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			-- filter out clients that you don't want to use
			return client.name ~= "tsserver" and client.name ~= "gopls" and client.name ~= "intelephense"
		end,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local default = function(client, bufnr)
	local telescopeBuiltins = require("telescope.builtin")
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
	vim.keymap.set("n", "gr", telescopeBuiltins.lsp_references, { buffer = 0 })
	vim.keymap.set("n", "gw", telescopeBuiltins.lsp_document_symbols, { buffer = 0 })
	vim.keymap.set("n", "<leader>t", telescopeBuiltins.treesitter, { buffer = 0 })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })
	vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = 0 })
	vim.keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })

	if client and client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
end

local clientCapabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig.gopls.setup({
	capabilities = clientCapabilities,
	on_attach = function(client, bufnr)
		default(client, bufnr)
	end,
	settings = {
		gopls = {
			analyses = {
				nilness = true,
				unusedparams = true,
				useany = true,
				unusedwrite = true,
			},
			staticcheck = true,
			usePlaceholders = true,
			experimentalUseInvalidMetadata = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- Tom, at some point you want to start using typescript.nvim
lspconfig.tsserver.setup({
	on_attach = function(client, bufnr)
		default(client, bufnr)
		local ts_utils = require("nvim-lsp-ts-utils")
		ts_utils.setup({})
		ts_utils.setup_client(client)
		vim.keymap.set("n", "go", ":TSLspOrganize<CR>", { buffer = 0 })
		vim.keymap.set("n", "gfr", ":TSLspRenameFile<CR>", { buffer = 0 })
		vim.keymap.set("n", "ga", ":TSLspImportAll<CR>", { buffer = 0 })
	end,
})

lspconfig.intelephense.setup({
	init_options = { licenceKey = "00G0KD8UUF391H9" },
	on_attach = function(client, bufnr)
		default(client, bufnr)
	end,
})

local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
local code_actions = null_ls.builtins.code_actions
local hover = null_ls.builtins.hover

null_ls.setup({
	on_attach = function(client, bufnr)
		default(client, bufnr)
	end,
	sources = {
		diagnostics.eslint,
		diagnostics.statix,
		code_actions.eslint,
		code_actions.statix,
		code_actions.shellcheck,
		formatting.prettier.with({
			prefer_local = "node_modules/.bin",
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"scss",
				"less",
				"html",
				"json",
				"php",
				"yaml",
				"markdown",
				"graphql",
			},
		}),
		formatting.stylua,
		formatting.nixfmt,
		hover.dictionary,
		diagnostics.hadolint,
		-- diagnostics.actionlint,
		diagnostics.shellcheck,
		formatting.shfmt.with({
			extra_args = { "-i", "2", "-sr", "-s", "-ci" },
		}),
		formatting.goimports,
		formatting.golines.with({
			extra_args = { "--base-formatter", "gofumpt" },
		}),
		diagnostics.mdl.with({
			extra_args = { "-r", "~MD013" },
		}),
	},
})

local emmetCapabilities = vim.lsp.protocol.make_client_capabilities()
emmetCapabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
	capabilities = emmetCapabilities,
	filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
})

local terraformCapabilities = vim.lsp.protocol.make_client_capabilities()
terraformCapabilities.textDocument.completion.completionItem.snippetSupport = true
terraformCapabilities.textDocument.completion.completionItem.server_capabilities = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

lspconfig.terraformls.setup({
	capabilities = terraformCapabilities,
	on_attach = function()
		default()
	end,
})

lspconfig.tflint.setup({
	on_attach = function()
		default()
	end,
})

lspconfig.rnix.setup({})

lspconfig.golangci_lint_ls.setup({
	init_options = {
		command = {
			"golangci-lint",
			"run",
			"-c",
			"~/.config/golangci/golangci.yaml",
		},
	},
})

lspconfig.yamlls.setup({})
