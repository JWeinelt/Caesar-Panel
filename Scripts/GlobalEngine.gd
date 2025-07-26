extends Node

signal caesar_authenticated
signal caesar_auth_failed(reason)
signal cloudnet_authenticated

signal services_got(data)
signal tasks_got(data)
signal clusters_got(data)
signal groups_got(data)

signal caesar_checked_connection(is_setup)
signal code_validated(valid)

signal server_config_loaded(data)
signal server_config_load_fail
signal config_server_change_ok

signal permission_send_success
signal user_action_success

signal got_users(data)
signal got_roles(data)
signal got_permissions(data)

signal loaded_weather(data)

# warning-ignore:unused_signal
signal background_image_use_toggle(use_image)

signal got_mc_uuid(mc_name, mc_uuid)

var client_version = "1.0.0"
var user_id = ""

var caesar_auth = ""
var cloudnet_auth = ""

var cloud_address = ""
var enable_cloud = false

var location = Vector2.ZERO

var server_setup_mode = false

var chat_server_port

var config_changed_keys = []

var user_permissions = []

var cs_settings = {
	"defaults": {
		"username": "",
		"caesar_host": "localhost",
		#"caesar_host": "play.codeblocksmc.com",
		"useSSL": false,
	},
	"client_version": "1.0.0",
	"clientSettings": {
		"useBorderlessWindow": false,
		"useVSync": true,
		"useTransparency": false,
		"useCorporateDesign": false,
		"used_background": "1",
		"blur_background": true,
		"blur_rate": 3.0,
		"own_background_file": "",
		"useBackgroundImage": false,
	}
}

var features_enabled = []

func _ready():
	load_config()
	apply_config()


func feature_enabled(feature) -> bool:
	return features_enabled.find(feature) != -1


func has_permission(permission) -> bool:
	return user_permissions.find(permission) != -1


func apply_config():
	if cs_settings.client_version != client_version:
		print("Config upgrade needed.")
	get_tree().get_root().set_transparent_background(GE.cs_settings.clientSettings.useTransparency)
	OS.window_borderless = GE.cs_settings.clientSettings.useBorderlessWindow


func request_location():
	$Weather/LocationService.request("https://ipinfo.io/json")


func caesar_tk():
	return ["Authorization: Bearer " + caesar_auth]


func cloudnet_tk():
	return ["Authorization: Bearer " + cloudnet_auth]


func caesar():
	var url = cs_settings.defaults.caesar_host
	if url.find(":") == -1: url = url + ":48000"
	if not url.begins_with("http://"): url = "http://" + url
	if not url.ends_with("/"): url = url + "/"
	return url


func cloudnet():
	if not cloud_address.begins_with("http://") and not cloud_address.begins_with("https://"):
		cloud_address = "http://" + cloud_address
	return cloud_address


func get_services():
	$CloudNET/Services.request(cloudnet() + "service", cloudnet_tk())


func get_tasks():
	$CloudNET/Tasks.request(cloudnet() + "task", cloudnet_tk())


func get_groups():
	$CloudNET/Groups.request(cloudnet() + "group", cloudnet_tk())


func get_clusters():
	$CloudNET/Clusters.request(cloudnet() + "cluster", cloudnet_tk())


func update_permissions(username, permissions):
	var body = {
		"username": username,
		"permissions": permissions
	}
	$Management/SendPermissions.request(caesar() + "user/permissions", caesar_tk(), false, HTTPClient.METHOD_POST, JSON.print(body))


func check_connection_caesar(address: String, ssl: bool, port: int):
	var mode = "http"
	if ssl: mode += "s"
	mode += "://"
	$Setup/ValidateCode.request(mode + address + ":%s/csetup/checkconnection" % str(port))
	cs_settings.defaults.caesar_host = mode + address


func request_setup_code_validation(code: int):
	var code_body = {
		"code": code
	}
	$Setup/ValidateCode.request(caesar() + "csetup/checkcode", [], false, HTTPClient.METHOD_POST, JSON.print(code_body))


func get_greeting():
	$Weather/WeatherGetter.request("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,is_day,weather_code" % [
		location.x, location.y
	])


func get_users():
	$Management/GetUsers.request(caesar() + "user", caesar_tk())


func get_roles():
	$Management/GetRoles.request(caesar() + "role", caesar_tk())


func get_permissions():
	$Management/GetPermissions.request(caesar() + "permission", caesar_tk())


func create_user(username, password):
	var body = {
		"username": username,
		"password": password,
		"discordID": ""
	}
	$Management/UserAction.request(caesar() + "user", caesar_tk(), false, HTTPClient.METHOD_POST, JSON.print(body))
	Worker.send_tray_type("user actions", "Creating user...", "INFO")


func create_role(role_name, color: Color):
	var parsed_color = str(str(color.r) + ";" + str(color.g) + ";" + str(color.b) + ";" + str(color.a))
	var body = {
		"name": role_name,
		"color": parsed_color
	}
	$Management/CreateRole.request(caesar() + "role", caesar_tk(), false, HTTPClient.METHOD_POST, JSON.print(body))


func get_server_config():
	$Management/GetConfig.request(caesar() + "config", caesar_tk())


func login(username, password):
	cs_settings.defaults.username = username
	save_config()
	var p = username + ":" + password
	var encoded = Marshalls.utf8_to_base64(p)
	$Auth/Auth.request(caesar() + "auth", ["Authorization: Basic " + encoded], false, HTTPClient.METHOD_POST)


func get_greeting_from_time(iso_time: String) -> String:
	# Beispiel-Input: "2025-05-02T17:30"
	var split_time = iso_time.split("T")
	if split_time.size() != 2:
		return "ERR-2931-UNKNOWN_TIME_FORMAT"
	
	var time_part = split_time[1]  # "17:30"
	var hour = int(time_part.split(":")[0])  # Nimm die Stunde
	
	if hour >= 5 and hour < 10:
		return "Good morning"
	elif hour >= 10 and hour < 12:
		return "Good day"
	elif hour >= 12 and hour < 17:
		return "Good afternoon"
	elif hour >= 17 and hour < 21:
		return "Good evening"
	else:
		return "Good night"


func save_config():
	var file = File.new()
	#file.open_encrypted_with_pass("user://config.cac", File.WRITE, "caesar-panel")
	file.open("user://config.cac", File.WRITE)
	file.store_var(cs_settings, true)
	file.close()


func load_config():
	print("Loading config")
	var file = File.new()
	if not file.file_exists("user://config.cac"): save_config()
	#file.open_encrypted_with_pass("user://config.cac", File.READ, "caesar-panel")
	file.open("user://config.cac", File.READ)
	cs_settings = file.get_var(true)


func _on_Auth_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	
	if response_code == 200:
		emit_signal("caesar_authenticated")
		print("Auth to Caesar endpoint successful")
		server_setup_mode = data.setupMode
		caesar_auth = data.token
		user_id = data.userID
		# Features
		if data.features.chat: features_enabled.append("Chat")
		if data.features.mail: features_enabled.append("Mails")
		if data.features.support: features_enabled.append("Support")
		if data.features.files: features_enabled.append("Files")
		
		chat_server_port = data.chatServer
		
		
		user_permissions = data.permissions
		print("Got " + str(user_permissions.size()) + " permissions in total.")
		
		
		if data.useCloudNET:
			cloud_address = data.cloudnet.host
			if cloud_address == "localhost" or cloud_address == "127.0.0.1":
				cloud_address = cs_settings.defaults.caesar_host
			var header = ["Authorization: Basic " + data.cloudnet.credentials]
			$Auth/AuthCN.request("http://" + cloud_address + "/api/v3/auth", header, false, HTTPClient.METHOD_POST)
			cloud_address = "http://" + cloud_address + "/api/v3/"
			enable_cloud = true
		else:
			enable_cloud = false
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		if response_code == 500:
			Worker.send_tray_type("Error", "Could not authenticate with Caesar (500)", "ERROR")
			return
		printerr("Unable to authenticate to Caesar endpoint")
		printerr("Code: %s" % str(response_code))
		printerr("Reason: %s" % str(data.reason))
		emit_signal("caesar_auth_failed", data.reason)


func _on_LocationService_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	var long = data.loc.split(",")[0]
	var lat = data.loc.split(",")[1]
	$Weather/WeatherGetter.request("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,is_day,weather_code" % [
		long, lat
	])
	location = Vector2(long, lat)




func send_config_change(data):
	for i in config_changed_keys:
		var val = data.get(i)
		if i == "configVersion" or i == "languageVersion": return # Read-only fields
		var body = {
			"key": i,
			"value": val,
			"type": get_value_type(val)
		}
		var sender = HTTPRequest.new()
		$Management.add_child(sender)
		sender.connect("request_completed", self, "_on_SendConfigChange_request_completed")
		sender.request(caesar() + "config", caesar_tk(), false, HTTPClient.METHOD_PUT, JSON.print(body))


func send_config_change_indiv(key, val):
		var body = {
			"key": key,
			"value": val,
			"type": get_value_type(val)
		}
		var sender = HTTPRequest.new()
		$Management.add_child(sender)
		sender.connect("request_completed", self, "_on_SendConfigChange_request_completed")
		sender.request(caesar() + "config", caesar_tk(), false, HTTPClient.METHOD_PUT, JSON.print(body))


func get_value_type(val):
	if val is int: return "INT"
	if val is String: return "STRING"
	if val is bool: return "BOOLEAN"
	else: return "UNKNOWN"


func request_mc_id(mc_name):
	$Minecraft/GetUUIDFromName.request("https://api.mojang.com/users/profiles/minecraft/" + mc_name)


func _on_WeatherGetter_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	emit_signal("loaded_weather", data)


func _on_AuthCN_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		printerr("Error while logging in to CloudNET: " + str(response_code))
		enable_cloud = false
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")
		return
	var data = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		print("CloudNET has been authenticated. Continuing...")
		cloudnet_auth = data.accessToken.token
		emit_signal("cloudnet_authenticated")
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")


func _on_Services_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	match response_code:
		200:
			emit_signal("services_got", data)
			return
	printerr("Could not load service data: " + str(response_code))


func _on_Tasks_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	match response_code:
		200:
			emit_signal("tasks_got", data)


func _on_Groups_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	match response_code:
		200:
			emit_signal("groups_got", data)


func _on_Clusters_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	match response_code:
		200:
			emit_signal("clusters_got", data)


func _on_Action_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		print("Action successful")


func _on_CheckConnection_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if data.success:
		emit_signal("caesar_checked_connection", data.setup)


func _on_ValidateCode_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200: return
	emit_signal("code_validated", data.success)


func _on_GetConfig_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		emit_signal("server_config_loaded", data)
		#emit_signal("server_config_loaded", body.get_string_from_utf8())
	else: 
		emit_signal("server_config_load_fail")
		printerr("Server configuration could not be loaded: " + str(response_code))


func _on_SendConfigChange_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		emit_signal("config_server_change_ok")


func _on_GetUsers_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		emit_signal("got_users", data)
	if response_code == HTTPClient.RESPONSE_FORBIDDEN:
		printerr("No permission to get user information")


func _on_GetUUIDFromName_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	emit_signal("got_mc_uuid", data.get("name"), data.get("id"))


func _on_UserAction_request_completed(_result, response_code, _headers, _body):
	if response_code != 200:
		Worker.send_tray_type("User actions", "Action could not be executed", "ERROR")
		emit_signal("user_action_success")
	else:
		get_users()
		Worker.send_tray_type("User actions", "User has been created", "INFO")


func _on_GetRoles_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	
	emit_signal("got_roles", data)


func _on_CreateRole_request_completed(_result, response_code, _headers, _body):
	if response_code != 200:
		Worker.send_tray_type("Role actions", "Action could not be executed", "ERROR")
	else:
		get_roles()
		Worker.send_tray_type("Role actions", "User has been created", "INFO")


func _on_GetPermissions_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		printerr("Could not load available permissions.")
		return
	var data = JSON.parse(body.get_string_from_utf8()).result
	emit_signal("got_permissions", data)


func _on_SendPermissions_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		emit_signal("permission_send_success")
