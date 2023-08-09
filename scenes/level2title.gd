extends Control


func _on_button_pressed():
	add_sibling(load("res://scenes/level2intro1.tscn").instantiate())
	queue_free()
