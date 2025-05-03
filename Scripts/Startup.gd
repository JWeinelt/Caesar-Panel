extends Control

func _ready():
	$Error.hide()
	get_tree().get_root().set_transparent_background(true)
	OS.window_borderless = true
	
	$Username/UEnter.text = GE.cs_settings.defaults.username


func _on_Exit_pressed():
	get_tree().quit()


func _on_Login_pressed():
	if $Username/UEnter.text.empty() or $Password/PEnter.text.empty():
		$Error.show()
		$Error.text = "Please provide a username and a password."


func _on_PEnter_text_entered(new_text):
	if $Username/UEnter.text.empty() or new_text.empty():
		$Error.show()
		$Error.text = "Please provide a username and a password."


func _on_UEnter_text_entered(new_text):
	if $Password/PEnter.text.empty() or new_text.empty():
		$Error.show()
		$Error.text = "Please provide a username and a password."
