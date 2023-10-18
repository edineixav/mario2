extends Area2D

signal pegou_moeda

func _on_Moeda_body_entered(body):
	if body.name == "Player":
		$AudioMoeda.play()
		emit_signal("pegou_moeda")
		queue_free()
