extends ColorRect



func _ready():
# warning-ignore:return_value_discarded
	GE.connect("background_image_use_toggle", self, "_on_background_update")


func _on_background_update(use_image):
	if use_image:
		color.a = 120 / 255
	else:
		color.a = 255 / 255
