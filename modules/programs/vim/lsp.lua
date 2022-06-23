local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(clients)
			-- filter out clients that you don't want to use
			return vim.tbl_filter(function(client)
				return client.name ~= "tsserver" and client.name ~= "gopls" and client.name ~= "intelephense"
			end, clients)
		end,
		bufnr = bufnr,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local default = function(client, bufnr)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
	vim.keymap.set("n", "g?", vim.lsp.diagnostic.show_line_diagnostics, { buffer = 0 })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })
	vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = 0 })
	vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })

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

lspconfig.gopls.setup({
	on_attach = function(client, bufnr)
		default(client, bufnr)
	end,
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
local code_actions = null_ls.builtins.code_actions
local hover = null_ls.builtins.hover

null_ls.setup({
	sources = {
		diagnostics.markdownlint,
		diagnostics.eslint,
		code_actions.eslint,
		code_actions.shellcheck,
		formatting.prettierd.with({
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

lspconfig.tflint.setup({})

lspconfig.golangci_lint_ls.setup({
	init_options = {
		command = {
			"golangci-lint",
			"run",
			"-c",
			"~/.golangci.yaml",
		},
	},
})
