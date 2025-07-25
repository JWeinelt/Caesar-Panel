extends Control

signal clicked(json)

var username = "New User"
var json


func change_name(username_new):
	username = username_new
	$Name.text = username


# warning-ignore:function_conflicts_variable
func username():
	return username


func _on_Layout_mouse_entered():
	$FX.play("hover_on")


func _on_Layout_mouse_exited():
	$FX.play("hover_off")


func _on_Layout_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("clicked", json)
