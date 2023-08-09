extends Control


func _on_button_pressed():
	add_sibling(load("res://scenes/level1intro1.tscn").instantiate())
	queue_free()
