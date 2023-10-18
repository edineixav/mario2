extends StaticBody2D

var life = 3

func _on_AreaImpacto_body_entered(body):
	life -= 1
	$Animador.play("bater")
	if life == 0:
		queue_free()
