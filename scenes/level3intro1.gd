extends Control


func _on_button_pressed():
	add_sibling(load("res://scenes/level3.tscn").instantiate())
	queue_free()
