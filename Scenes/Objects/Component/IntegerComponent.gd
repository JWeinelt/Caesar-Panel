extends Label

signal value_changed(value, data_name)

export var initial_value = 0
export var key = ""

var data_name = ""

func _ready():
	text = key.capitalize()
	$SpinBox.value = initial_value
	
	var font = get_font("font")
	var text_size = font.get_string_size(key)
	
	$SpinBox.rect_position.x = text_size.x + 10


func value():
	return $SpinBox.value


func _on_SpinBox_value_changed(value):
	emit_signal("value_changed", value, data_name)
