extends Control

func display(text, value):
	$Name.text = text.capitalize()
	$Value.rect_position.x = $Name.rect_size.x + 40
	$Value.text = value
