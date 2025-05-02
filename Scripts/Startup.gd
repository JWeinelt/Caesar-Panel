extends Control

func _ready():
	get_tree().get_root().set_transparent_background(true)
	OS.window_borderless = true
