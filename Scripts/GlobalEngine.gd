extends Node

signal caesar_authenticated
signal caesar_auth_failed
signal cloudnet_authenticated

signal services_got(data)
signal tasks_got(data)
signal clusters_got(data)
signal groups_got(data)

signal caesar_checked_connection(is_setup)
signal code_validated(valid)

signal loaded_weather

var caesar_auth = ""
var cloudnet_auth = ""

var cloud_address = ""

var location = Vector2.ZERO


var cs_settings = {
	"defaults": {
		"username": "",
		"caesar_host": "localhost",
		"useSSL": false,
		"used_background": "1",
		"blur_background": true,
	},
	"client_version": "0.0.1",
}

func _ready():
	load_config()


func request_location():
	$Weather/LocationService.request("https://ipinfo.io/json")


func caesar_tk():
	return ["Authorization: Bearer " + caesar_auth]


func cloudnet_tk():
	return ["Authorization: Bearer " + cloudnet_auth]


func caesar():
	return cs_settings.defaults.caesar_host


func cloudnet():
	return cloud_address


func get_services():
	$CloudNET/Services.request(cloudnet() + "services", cloudnet_tk())


func get_tasks():
	$CloudNET/Tasks.request(cloudnet() + "task", cloudnet_tk())


func get_groups():
	$CloudNET/Groups.request(cloudnet() + "group", cloudnet_tk())


func get_clusters():
	$CloudNET/Clusters.request(cloudnet() + "cluster", cloudnet_tk())


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


func get_greeting_from_time(iso_time: String) -> String:
	# Beispiel-Input: "2025-05-02T17:30"
	var split_time = iso_time.split("T")
	if split_time.size() != 2:
		return "ERR-2931-UNKNOWN_TIME_FORMAT"
	
	var time_part = split_time[1]  # "17:30"
	var hour = int(time_part.split(":")[0])  # Nimm die Stunde
	
	if hour >= 5 and hour < 10:
		return "Good morning"
	elif hour >= 10 and hour < 17:
		return "Hello"
	elif hour >= 17 and hour < 21:
		return "Good evening"
	else:
		return "Good night"


func save_config():
	var file = File.new()
	file.open_encrypted_with_pass("user://config.cac", File.WRITE, "caesar-panel")
	file.store_var(cs_settings, true)
	file.close()


func load_config():
	var file = File.new()
	if not file.file_exists("user://config.cac"): save_config()
	file.open_encrypted_with_pass("user://config.cac", File.READ, "caesar-panel")
	cs_settings = file.get_var(true)


func _on_Auth_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	
	if response_code == 200:
		if data.useCloudNET:
			var header = ["Authorization: Basic " + data.cloudnet.credentials]
			$Auth/AuthCN.request("http://" + data.cloudnet.host + "/auth", header, false, HTTPClient.METHOD_POST)
			cloud_address = "http://" + data.cloudnet.host + "/"
			emit_signal("caesar_authenticated")
	else:
		emit_signal("caesar_auth_failed")


func _on_LocationService_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	var long = data.loc.split(",")[0]
	var lat = data.loc.split(",")[1]
	$Weather/WeatherGetter.request("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,is_day,weather_code" % [
		long, lat
	])
	location = Vector2(long, lat)


func _on_WeatherGetter_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	print(get_greeting_from_time(data.current.time))
	emit_signal("loaded_weather")


func _on_AuthCN_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		cloudnet_auth = data.accessToken.token
		emit_signal("cloudnet_authenticated")


func _on_Services_request_completed(_result, response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	match response_code:
		200:
			emit_signal("services_got", data)


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
