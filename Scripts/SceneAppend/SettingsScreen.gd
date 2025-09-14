extends Control

onready var serv = $ServerSettings
onready var client = $ClientSettings

onready var cBtn = $ViewClientSett
onready var sBtn = $ViewServerSett

func _ready():
	if not GE.has_permission("caesar.admin.change-config"):
		serv.hide()
		client.show()
		cBtn.hide()
		sBtn.hide()
		$ClientSettings/HeaderClient.text = "Preferences"
		return
	serv.hide()
	client.show()
	cBtn.disabled = true
	sBtn.disabled = false
	
	display_settings()


func display_settings():
	$ClientSettings/Design/UseBackground.pressed = GE.cs_settings.clientSettings.useBackgroundImage
	$ClientSettings/Performance/TransparentEffects.pressed = GE.cs_settings.clientSettings.useTransparency
	$ClientSettings/Performance/BorderlessWindow.pressed = GE.cs_settings.clientSettings.useBorderlessWindow
	var to_display = "bg" + str(GE.cs_settings.clientSettings.used_background)
	for i in range(0, $ClientSettings/Design/BgSelector.get_item_count()):
		if $ClientSettings/Design/BgSelector.get_item_text(i) == to_display:
			$ClientSettings/Design/BgSelector.select(i)
	$ClientSettings/Design/ApplyBlur.pressed = GE.cs_settings.clientSettings.blur_background
	$ClientSettings/Design/BlurRate.value = GE.cs_settings.clientSettings.blur_rate
	$ClientSettings/Design/UseCorporate.pressed = GE.cs_settings.clientSettings.useCorporateDesign
	$ClientSettings/Design/BlurBackground.pressed = GE.cs_settings.clientSettings.blur_background


func _on_UseBackground_toggled(button_pressed):
	get_parent().update_background_mode(button_pressed)
	GE.cs_settings.clientSettings.useBackgroundImage = button_pressed
	GE.emit_signal("background_image_use_toggle", button_pressed)


func _on_TransparentEffects_toggled(button_pressed):
	get_tree().get_root().set_transparent_background(button_pressed)
	GE.cs_settings.clientSettings.useTransparency = button_pressed
	GE.save_config()


func _on_BorderlessWindow_toggled(button_pressed):
	OS.window_borderless = button_pressed
	GE.cs_settings.clientSettings.useBorderlessWindow = button_pressed
	GE.save_config()


func _on_BgSelector_item_selected(index):
	var bg = int($ClientSettings/Design/BgSelector.get_item_text(index).replace("bg", ""))
	$ClientSettings/Design/Preview.get("custom_styles/panel").texture = load(
		"res://Assets/Backgrounds/non_blur/bg%s.png" % bg
	)
	get_parent().change_bg_image(bg)
	GE.cs_settings.clientSettings.used_background = bg
	GE.save_config()


func _on_ApplyBlur_pressed():
	if GE.cs_settings.clientSettings.blur_background:
		get_parent().update_bg_blur($ClientSettings/Design/BlurRate.value)
	GE.cs_settings.clientSettings.blur_rate = $ClientSettings/Design/BlurRate.value
	GE.save_config()


func _on_ViewClientSett_pressed():
	serv.hide()
	client.show()
	cBtn.disabled = true
	sBtn.disabled = false


func _on_ViewServerSett_pressed():
	serv.show()
	client.hide()
	cBtn.disabled = false
	sBtn.disabled = true


func _on_UseCorporate_toggled(button_pressed):
	GE.cs_settings.clientSettings.useCorporateDesign = button_pressed
	GE.save_config()


func _on_BlurBackground_toggled(button_pressed):
	GE.cs_settings.clientSettings.blur_background = button_pressed
	GE.save_config()
