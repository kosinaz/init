extends Control


func _on_button_pressed():
	add_sibling(load("res://scenes/home.tscn").instantiate())
	queue_free()
