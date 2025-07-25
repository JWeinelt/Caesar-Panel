extends Control

func _ready():
	$Error.hide()
	get_tree().get_root().set_transparent_background(true)
	OS.window_borderless = true
	
	$Username/UEnter.text = GE.cs_settings.defaults.username
	
	if not $Username/UEnter.text.empty():
		$Password/PEnter.grab_focus()
	
# warning-ignore:return_value_discarded
	GE.connect("caesar_auth_failed", self, "_on_caesar_auth_fail")


func login():
	$Loader.show_loading(30)
	print("Logging in...")
	var username = $Username/UEnter.text
	var password = $Password/PEnter.text
	if username.empty() or password.empty():
		$Error.show()
		$Error.text = "Please provide a username and a password."
		return
	GE.login(username, password)


func _on_Exit_pressed():
	get_tree().quit()


func _on_Login_pressed():
	login()


func _on_PEnter_text_entered(_new_text):
	login()


func _on_UEnter_text_entered(_new_text):
	login()


func _on_caesar_auth_fail(reason):
	$Error.show()
	$Error.text = "Response from server: " + reason


func _on_ShowPW_toggled(button_pressed):
	$Password/PEnter.secret = button_pressed
