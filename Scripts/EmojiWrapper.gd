extends Node

func _ready():
	pass
	

# DEBUG Method to scale the emojis
func scale_images_in_folder(folder_path: String) -> void:
	# Öffne den Ordner
	var dir = Directory.new()
	if dir.open(folder_path) != OK:
		print("Fehler: Der Ordner konnte nicht geöffnet werden.")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".jpeg"):
			var file_path = folder_path.plus_file(file_name)
			print("Bearbeite: " + file_path)

			# Lade das Bild
			var image = Image.new()
			if image.load(file_path) == OK:
				var original_width = image.get_width()
				var original_height = image.get_height()
				image.resize(original_width / 2, original_height / 2)  # 50% skalieren

				# Speichere die skalierte Version
				if image.save_png(file_path) != OK:
					print("Fehler beim Speichern von: " + file_path)
			else:
				print("Fehler beim Laden von: " + file_path)
		
		file_name = dir.get_next()

	dir.list_dir_end()
	print("Alle Bilder wurden verarbeitet.")


func get_emoji_name(sprite_id, frame_id):
	pass


func get_sheet_size(sheet_id) -> Vector2:
	match sheet_id:
		0:
			return Vector2(16, 10)
		1:
			return Vector2(16, 9)
		2:
			return Vector2(16, 6)
		3:
			return Vector2(16, 10)
		4:
			return Vector2(16, 12)
		5:
			return Vector2(16, 12)
		6:
			return Vector2(16, 12)
		7:
			return Vector2(16, 5)
		8:
			return Vector2(16, 10)
		9:
			return Vector2(16, 8)
		10:
			return Vector2(16, 7)
		11:
			return Vector2(16, 8)
		12:
			return Vector2(16, 8)
		13:
			return Vector2(16, 2)
		14:
			return Vector2(16, 9)
		15:
			return Vector2(16, 2)
		16:
			return Vector2(16, 9)
		17:
			return Vector2(16, 8)
		18:
			return Vector2(16, 4)
		19:
			return Vector2(16, 10)
		20:
			return Vector2(16, 6)
		21:
			return Vector2(16, 9)
		22:
			return Vector2(16, 7)
		23:
			return Vector2(16, 8)
		24:
			return Vector2(8, 1)
		25:
			return Vector2(16, 8)
		26:
			return Vector2(16, 9)
		27:
			return Vector2(3, 1)
		28:
			return Vector2(16, 9)
		29:
			return Vector2(16, 6)
	return Vector2(0, 0)


func get_sheet_places(sheet_id) -> float:
	return get_sheet_size(sheet_id).x * get_sheet_size(sheet_id).y


func get_sheet_name(id):
	return get_sheet_path(int(id)).replace("res://assets/mji/sheets/", "").replace(".png", "").replace("people_body", "people")


func get_sheet_path(id) -> String:
	match id:
		0:
			return "res://assets/mji/sheets/smileys.png"
		1:
			return "res://assets/mji/sheets/people_body1.png"
		2:
			return "res://assets/mji/sheets/people_body2.png"
		3:
			return "res://assets/mji/sheets/people_body3.png"
		4:
			return "res://assets/mji/sheets/people_body4.png"
		5:
			return "res://assets/mji/sheets/people_body5.png"
		6:
			return "res://assets/mji/sheets/peoplebody6.png"
		7:
			return "res://assets/mji/sheets/people_body7.png"
		8:
			return "res://assets/mji/sheets/people_body8.png"
		9:
			return "res://assets/mji/sheets/people_body9.png"
		10:
			return "res://assets/mji/sheets/people_body10.png"
		11:
			return "res://assets/mji/sheets/people_body11.png"
		12:
			return "res://assets/mji/sheets/people_body12.png"
		13:
			return "res://assets/mji/sheets/people_body13.png"
		14:
			return "res://assets/mji/sheets/people_body14.png"
		15:
			return "res://assets/mji/sheets/animals.png"
		16:
			return "res://assets/mji/sheets/food.png"
		17:
			return "res://assets/mji/sheets/travel1.png"
		18:
			return "res://assets/mji/sheets/travel2.png"
		19:
			return "res://assets/mji/sheets/activities.png"
		20:
			return "res://assets/mji/sheets/objects1.png"
		21:
			return "res://assets/mji/sheets/objects2.png"
		22:
			return "res://assets/mji/sheets/symbols1.png"
		23:
			return "res://assets/mji/sheets/symbols2.png"
		24:
			return "res://assets/mji/sheets/flags1.png"
		25:
			return "res://assets/mji/sheets/flags2.png"
		26:
			return "res://assets/mji/sheets/flags3.png"
		27:
			return "res://assets/mji/sheets/flags4.png"
		28:
			return "res://assets/mji/sheets/extras1.png"
		29:
			return "res://assets/mji/sheets/extras2.png"
	return ""
