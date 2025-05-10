extends Label

signal value_changed(value, data_name)

export var initial_value = ""
export var key = ""

var data_name = ""


func _ready():
	text = key.capitalize()
	$LineEdit.text = initial_value
	
	var font = get_font("font")
	var text_size = font.get_string_size(key)
	var text_size_edit = font.get_string_size(initial_value)
	if text_size_edit.x < 180:
		$LineEdit.rect_size.x = text_size_edit.x
	else: $LineEdit.rect_size.x = 180
	
	$LineEdit.rect_position.x = text_size.x + 10
	
	if key.to_lower().find("secret") != -1:
		$LineEdit.secret = true

func value():
	return $LineEdit.text


func _on_LineEdit_text_changed(new_text):
	emit_signal("value_changed", new_text, data_name)
