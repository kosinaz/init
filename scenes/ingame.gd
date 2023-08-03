extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_up_pressed():
	$%Agent.position.y -= 6


func _on_right_pressed():
	$%Agent.position.x += 6


func _on_down_pressed():
	$%Agent.position.y += 6


func _on_left_pressed():
	$%Agent.position.x -= 6
