extends Node


var ws: WebSocketClient = null

func _ready():
	ws = WebSocketClient.new()
# warning-ignore:return_value_discarded
	ws.connect("data_received", self, "_on_data_received")
	var err = ws.connect_to_url("http://localhost:41539")
	if err == OK:
		print("Connected to worker")


func _process(_delta):
	if ws != null: ws.poll()




func _on_data_received():
	var message := ws.get_peer(1).get_packet().get_string_from_utf8()
	var _vm = JSON.parse(message).result


func send_message(message):
	var err = ws.get_peer(1).put_packet(message.to_utf8())
	if err != OK:
		printerr("Problem while sending message via WebSocket (Console): " + str(err))


func send_tray(title, message):
	var err = ws.get_peer(1).put_packet(str("tray-message;" + title + ";" + message).to_utf8())
	if err != OK:
		print_debug("Problem while sending tray message via WebSocket (Console): " + str(err))
	
func send_tray_type(title, message, type):
	var err = ws.get_peer(1).put_packet(str("tray-message;" + title + ";" + message + ";" + type).to_utf8())
	if err != OK:
		print_debug("Problem while sending tray message via WebSocket (Console): " + str(err))
	
