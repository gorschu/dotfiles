require("bufferline").setup{
	options = {
		numbers = "ordinal",
		numberstyle = "none",
		always_show_bufferline = true,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    return "("..count..")"
                end,
                offsets = {{filetype = "NvimTree", text = "NvimTree", text_align = "left", highlight = "Directory" }, { filetype = "tagbar", text = "Tagbar", text_align = "right", highlight = "Directory"}, { filetype="packer", text = "Packer", text_align="left", highlight="Directory"}},
		sort_by = "relative_directory"

	}
}
vim.api.nvim_set_keymap('n', "<leader>bp", "<cmd>BufferLinePick<cr>", { noremap = true, silent = true })

