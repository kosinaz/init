extends Control


func _on_button_pressed():
	add_sibling(load("res://scenes/ingame.tscn").instantiate())
	queue_free()
