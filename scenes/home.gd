extends Control


func _ready():
	if not get_parent().has_node("Music"):
		add_sibling.call_deferred(load("res://scenes/music.tscn").instantiate())

func _on_button_pressed():
	add_sibling(load("res://scenes/level1title.tscn").instantiate())
	queue_free()
