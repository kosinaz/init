@tool
extends Node2D


@export
var id = 0


func _process(_delta):
	$Sprite2D.texture.region = Rect2(id * 6, 0, 6, 6)
