sisyphean.styles = {
	padding = {
		all_2 = function(el)
			el.style.top_padding = 2
			el.style.bottom_padding = 2
			el.style.left_padding = 2
			el.style.right_padding = 2
		end,
		top_2 = function(el)
			el.style.top_padding = 2
		end,
		left_2 = function(el)
			el.style.left_padding = 2
		end,
		
		all_4 = function(el)
			el.style.top_padding = 4
			el.style.bottom_padding = 4
			el.style.left_padding = 4
			el.style.right_padding = 4
		end,
		top_4 = function(el)
			el.style.top_padding = 4
		end,
		left_4 = function(el)
			el.style.left_padding = 4
		end
	},
	
	font_color = {
		set = function(el, RGBA)
			el.style.font_color = RGBA
		end,
	
		red = function(el)
			el.style.font_color = sisyphean.color.red
		end,
		brightred = function(el)
			el.style.font_color = sisyphean.color.brightred
		end,
		
		green = function(el)
			el.style.font_color = sisyphean.color.green
		end,
		
		dullyellow = function(el)
			el.style.font_color = sisyphean.color.dullyellow
		end
	},
	
	font = {
		normal = function(el)
			el.style.font = "default"
		end,
		normal_semibold = function(el)
			el.style.font = "default-semibold"
		end,
		normal_bold = function(el)
			el.style.font = "default-bold"
		end,
	},
	
	item = {
		finished_frame_text = function(el)
			el.style.single_line = false
			el.style.width = 300
		end
	}
}