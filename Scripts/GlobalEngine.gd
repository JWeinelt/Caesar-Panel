extends Node

var caesar_auth = ""
var cloudnet_auth = ""

var location = Vector2.ZERO

func _ready():
	$Weather/LocationService.request("https://ipinfo.io/json")


func _on_Auth_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_LocationService_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	var long = data.loc.split(",")[0]
	var lat = data.loc.split(",")[1]
	$Weather/WeatherGetter.request("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,is_day,weather_code" % [
		long, lat
	])
	location = Vector2(long, lat)


func _on_WeatherGetter_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	print(get_greeting_from_time(data.current.time))


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
