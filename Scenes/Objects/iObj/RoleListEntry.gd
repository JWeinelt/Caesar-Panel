extends Control

signal clicked(json)

var rolename = "New Role"
var json

func _ready():
	var original_stylebox = $Bg.get_stylebox("panel") as StyleBoxFlat
	var unique_stylebox = original_stylebox.duplicate()
	$Bg.add_stylebox_override("panel", unique_stylebox)


func change_name(username_new):
	rolename = username_new
	$Name.text = rolename

func change_color(color: String):
	var red = color.split(";")[0]
	var green = color.split(";")[1]
	var blue = color.split(";")[2]
	var alpha = color.split(";")[3]
	var real_color = Color(int(red), int(green), int(blue), int(alpha))
	var hover_color = Color(int(red) + 10, int(green) + 10, int(blue) + 10, int(alpha))
	$FX.get_animation("hover_off").track_set_key_value(0, 0, hover_color)
	$FX.get_animation("hover_off").track_set_key_value(0, 1, real_color)
	$FX.get_animation("hover_on").track_set_key_value(0, 1, hover_color)
	$FX.get_animation("hover_on").track_set_key_value(0, 0, real_color)
	$FX.get_animation("RESET").track_set_key_value(0, 0, real_color)


# warning-ignore:function_conflicts_variable
func role_name():
	return rolename


func _on_Layout_mouse_entered():
	$FX.play("hover_on")


func _on_Layout_mouse_exited():
	$FX.play("hover_off")


func _on_Layout_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("clicked", json)
