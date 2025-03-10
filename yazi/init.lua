require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
	enter_mode = "first",
})

require("starship"):setup()

require("git"):setup()

require("full-border"):setup({
	type = ui.Border.ROUNDED,
})
