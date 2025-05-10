extends Label

signal value_changed(value, data_name)

export var initial_value = false
export var key = ""

var data_name = ""

func _ready():
	text = key.capitalize()
	$Check.pressed = initial_value
	
	var font = get_font("font")
	var text_size = font.get_string_size(key)
	
	$Check.rect_position.x = text_size.x + 10


func value():
	return $Check.pressed


func _on_Check_toggled(button_pressed):
	emit_signal("value_changed", button_pressed, data_name)
