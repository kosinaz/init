extends Node2D


@export
var id = 0


var movement_tween = null


func _exit_tree():
	if is_instance_valid(movement_tween):
		movement_tween.kill()
