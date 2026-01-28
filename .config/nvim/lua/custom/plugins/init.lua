-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

	"andweeb/presence.nvim",

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			quickfile = { enabled = true },
			terminal = { enabled = true },
			lazygit = { enabled = true },
		},
		keys = {
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
		},
	},

	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		-- dependencies = { '3rd/image.nvim' },
		build = ":UpdateRemotePlugins",
		--   init = function()
		--     vim.g.molten_image_provider = 'image.nvim'
		--   end,
	},

	-- {
	--   '3rd/image.nvim',
	--   opts = {
	--     backend = 'ueberzug',
	--   },
	-- },
	--

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "okular"

			vim.g.vimtex_compiler_latexmk = {
				executable = "/usr/bin/latexmk",
				options = {
					"-shell-escape",
					"-pdf",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
		end,
	},
	{
		"42paris/42header",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {
			indent = {
				char = "▏",
			},
			scope = { enabled = false },
		},
	},
	{
		"github/copilot.vim",
	},
	{
		"jbyuki/instant.nvim",
		config = function()
			vim.g.instant_username = "Karoo"
		end,
	},
	{
		"ShouxTech/rojo.nvim",
		opts = {},
	},
	{
		"ThePrimeagen/99",
		config = function()
			local _99 = require("99")

			-- Auto-create tmp directory for 99 plugin
			local cwd = vim.uv.cwd()
			vim.fn.mkdir(cwd .. "/tmp", "p")

			-- For logging that is to a file if you wish to trace through requests
			-- for reporting bugs, i would not rely on this, but instead the provided
			-- logging mechanisms within 99.  This is for more debugging purposes
			local basename = vim.fs.basename(cwd)
			_99.setup({
				model = "anthropic/claude-sonnet-4-20250514",
				logger = {
					level = _99.DEBUG,
					path = "/tmp/" .. basename .. ".99.debug",
					print_on_error = true,
				},

				--- WARNING: if you change cwd then this is likely broken
				--- ill likely fix this in a later change
				---
				--- md_files is a list of files to look for and auto add based on the location
				--- of the originating request.  That means if you are at /foo/bar/baz.lua
				--- the system will automagically look for:
				--- /foo/bar/AGENT.md
				--- /foo/AGENT.md
				--- assuming that /foo is project root (based on cwd)
				md_files = {
					"AGENT.md",
				},
			})

			-- Create your own short cuts for the different types of actions
			vim.keymap.set("n", "<leader>9f", function()
				_99.fill_in_function()
			end)
			-- take extra note that i have visual selection only in v mode
			-- technically whatever your last visual selection is, will be used
			-- so i have this set to visual mode so i dont screw up and use an
			-- old visual selection
			--
			-- likely ill add a mode check and assert on required visual mode
			-- so just prepare for it now
			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end)

			--- if you have a request you dont want to make any changes, just cancel it
			vim.keymap.set("v", "<leader>9s", function()
				_99.stop_all_requests()
			end)
		end,
	},
}
