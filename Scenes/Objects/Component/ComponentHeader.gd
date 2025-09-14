extends Label

export var header_name = "Example"
export var key = ""


func _ready():
	text = header_name.capitalize()
	


func get_children_json(node: Node = null) -> Dictionary:
	var result = {}

	if node == null:
		node = $Children

	for child in node.get_children():
		if not child is Node:
			continue
		
		if (not child.has_method("value")):
			continue

		var keys = child.key
		var val = child.value()

		if child.get_child_count() > 0:
			var nested = get_children_json(child)
			if typeof(val) == TYPE_DICTIONARY:
				val = val.duplicate()
				for k in nested.keys():
					val[k] = nested[k]
			elif nested.size() > 0:
				val = {
					"value": val,
					"children": nested
				}
		
		result[keys] = val
	
	return result


func value():
	return get_children_json()


func add_child_header(node):
	$Children.add_child(node)


func adjust_y():
	rect_min_size.y = $Children.get_child_count() * 40 + 60
