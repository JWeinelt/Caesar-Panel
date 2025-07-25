extends Panel



func _ready():
# warning-ignore:return_value_discarded
	GE.connect("background_image_use_toggle", self, "_on_background_update")


func _on_background_update(use_image):
	print("Using backgound image: " + str(use_image))
	var original_stylebox = get_stylebox("panel") as StyleBoxFlat
	var unique_stylebox: StyleBoxFlat = original_stylebox.duplicate()
	if use_image:
		unique_stylebox.bg_color.a = 120 / 255
	else:
		unique_stylebox.bg_color.a = 255 / 255
	add_stylebox_override("panel", unique_stylebox)
