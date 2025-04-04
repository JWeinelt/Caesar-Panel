extends Node

signal login_success
signal login_failed
signal got_data_services(json)
signal got_data_tasks(json)
signal got_data_clusters(json)
signal got_data_groups(json)

var services = {}
var tasks = {}

var token = ""
var refresh_token = ""

var cloudnet_address = "http://85.202.163.107:2812/api/v3/"
var cloudnet_version = "v4-RC11.2"

func _ready():
	if not cloudnet_address.ends_with("/"): cloudnet_address += "/"
	login("SystemAdmin", "dwaih2b1I45")


func login(username, password):
	print("Starting login process, CloudNET...")
	var text_bytes = str(username, ":", password).to_utf8()
	var base64_string = Marshalls.raw_to_base64(text_bytes)
	$Req/Login.request(cloudnet_address + "auth", ["Authorization: Basic " + base64_string], false, HTTPClient.METHOD_POST)


func end():
	print("Disconnecting from CloudNET...")
	$Req/SessionEnd.request(cloudnet_address + "auth/revoke", headers(), false, HTTPClient.METHOD_POST)


func get_services():
	$Req/GetServices.request(cloudnet_address + "service", headers())


func headers() -> Array:
	return ["Authorization: Bearer " + token]


func cloudnet():
	return cloudnet_address


func _on_Login_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if data == null:
		return
	token = data.accessToken.token
	print("Successfully authenticated in CloudNET.")
	emit_signal("login_success")
	get_services()


func _on_SessionEnd_request_completed(result, response_code, headers, body):
	get_tree().quit()


func _on_GetServices_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	services = data
	emit_signal("got_data_services", data)
