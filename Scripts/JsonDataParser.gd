extends Node

signal component_value_change(value, data_name)

var active_data = {}


func parse(json: String, data_name: String, node_to_attach_components):
	var dir: Dictionary = JSON.parse(json).result
	for key in dir.keys():
		if dir.get(key) is int:
			var comp = create_int_component(key, dir.get(key))
			comp.data_name = data_name
			comp.connect("value_changed", self, "_on_component_value_change")
			attach_component(node_to_attach_components, comp)
		if dir.get(key) is String:
			var comp = create_string_component(key, dir.get(key))
			comp.data_name = data_name
			comp.connect("value_changed", self, "_on_component_value_change")
			attach_component(node_to_attach_components, comp)
		if dir.get(key) is bool:
			var comp = create_bool_component(key, dir.get(key))
			comp.data_name = data_name
			comp.connect("value_changed", self, "_on_component_value_change")
			attach_component(node_to_attach_components, comp)
		
		if dir.get(key) is Dictionary:
			var header = create_component_header(key)
			header.header_name = key
			attach_component(node_to_attach_components, header)
			parse(JSON.print(dir.get(key)), data_name, header)
			header.adjust_y()


func attach_component(node, comp):
	if node.has_method("add_child_header"):
		node.add_child_header(comp)
		return
	node.add_child(comp)


func create_int_component(key, initial_value):
	var scene = load("res://Scenes/Objects/Component/IntegerComponent.tscn").instance()
	scene.initial_value = initial_value
	scene.key = key
	return scene


func create_string_component(key, initial_value):
	var scene = load("res://Scenes/Objects/Component/StringComponent.tscn").instance()
	scene.initial_value = initial_value
	scene.key = key
	return scene


func create_bool_component(key, initial_value):
	var scene = load("res://Scenes/Objects/Component/BoolComponent.tscn").instance()
	scene.initial_value = initial_value
	scene.key = key
	return scene


func create_component_header(key):
	var scene = load("res://Scenes/Objects/Component/ComponentHeader.tscn").instance()
	scene.key = key
	return scene


func _on_component_value_change(value, data_name):
	active_data[data_name] = true
	emit_signal("component_value_change", value, data_name)
