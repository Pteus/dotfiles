vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- defaults:
		-- https://neovim.io/doc/user/news-0.11.html#_defaults
		local builtin = require("telescope.builtin")
		map("gd", builtin.lsp_definitions, "Goto definition")
		map("gr", builtin.lsp_references, "Goto references")
		map("gi", builtin.lsp_implementations, "Goto implementation")
		map("gt", builtin.lsp_type_definitions, "Goto type definition")
		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gv", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")
		map("gl", vim.diagnostic.open_float, "Show diagnostics under cursor")
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
		map("<leader>cr", vim.lsp.buf.rename, "Rename all references")
		map("<leader>cf", vim.lsp.buf.format, "Format")

		map("<leader>sd", function()
			builtin.diagnostics({ bufnr = 0 })
		end, "Show file diagnostics")
		map("<leader>sD", builtin.diagnostics, "show workspace diagnostics")
		map("<leader>ss", builtin.lsp_document_symbols, "Show Document Symbols")
		map("<leader>sS", builtin.lsp_dynamic_workspace_symbols, "Show Workspace Symbols")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			-- When cursor stops moving: Highlights all instances of the symbol under the cursor
			-- When cursor moves: Clears the highlighting
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- When LSP detaches: Clears the highlighting
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})
