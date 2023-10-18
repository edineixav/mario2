extends Area2D



func _ready():
	pass 


func _on_Node2D_body_entered(body):
	if body is Player:
		body.die()
