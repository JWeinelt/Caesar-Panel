extends Node

signal plugins_got(data)

func fetch_plugins():
	$GetPlugins.request("https://api.caesarnet.cloud/api/market/plugin")


func _on_GetPlugins_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	
	emit_signal("plugins_got", data)
