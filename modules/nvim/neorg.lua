require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					Life = "~/Notes/Life",
					ILM = "~/Notes/ILM",
				},
			},
		},
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.qol.todo_items"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {
			config = {
				extensions = "all",
			},
		},
		["core.concealer"] = {
			config = {
				-- markup_preset = "dimmed",
				markup_preset = "conceal",
				icon_preset = "diamond",
				-- icon_preset = "varied",
				icons = {
					marker = {
						enabled = true,
						icon = " ",
					},
					todo = {
						enable = true,
						pending = {
							-- icon = ""
							icon = "",
						},
						uncertain = {
							icon = "?",
						},
						urgent = {
							icon = "",
						},
						on_hold = {
							icon = "",
						},
						cancelled = {
							icon = "",
						},
					},
					heading = {
						enabled = true,
						level_1 = {
							icon = "◈",
						},

						level_2 = {
							icon = " ◇",
						},

						level_3 = {
							icon = "  ◆",
						},
						level_4 = {
							icon = "   ❖",
						},
						level_5 = {
							icon = "    ⟡",
						},
						level_6 = {
							icon = "     ⋄",
						},
					},
				},
			},
		},
		["core.presenter"] = {
			config = {
				zen_mode = "zen-mode",
				slide_count = {
					enable = true,
					position = "top",
					count_format = "[%d/%d]",
				},
			},
		},
	},
})
