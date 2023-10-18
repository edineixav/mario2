extends KinematicBody2D

class_name Player

export var gravity = 10
export var walk_speed = 150
var mov_horizontal = 0.0
var noAr = false
export var jump_force = -250
export var velocity = Vector2()
export var can_double_jump = true
export var coins = 0
var vivo = true
signal morreu
signal fimAnimacao
signal concluiu

func _ready():
	Serial.connect("direita",self,"_on_direita")
	Serial.connect("esquerda",self,"_on_esquerda")
	Serial.connect("parado",self,"_on_parado")
	Serial.connect("pulo",self,"_on_pulo")
	Serial.connect("naoPulo",self,"_on_naoPulo")

func _on_direita():
	mov_horizontal = 1.0

func _on_esquerda():
	mov_horizontal = -1.0

func _on_parado():
	mov_horizontal = 0.0

func _on_pulo():
	noAr = true


func _physics_process(delta):
	if vivo:
		if is_on_ceiling():
			velocity.y = 0
		
		if not is_on_floor():
			velocity.y += gravity
		
		if is_on_floor():
			can_double_jump = true
		
		#var mov_horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
		velocity.x = mov_horizontal * walk_speed
		
		if noAr and is_on_floor():
			noAr = false
			velocity.y = jump_force
			$AudioPulo.play()
		elif noAr and can_double_jump:
			noAr = false
			velocity.y = jump_force
			can_double_jump = false
			$AudioPulo.play()
		
		if velocity.x > 0:
			$Animacao.flip_h = false
		elif velocity.x < 0:
			$Animacao.flip_h = true
		
		if is_on_floor():
			if abs(velocity.x) > 0:
				$Animacao.play("walk")
			else:
				$Animacao.play("idle")
		else:
			$Animacao.play("jump")
		
		move_and_slide(velocity, Vector2.UP)

func _on_Player_pontua():
	if coins < 10:
		coins += 1
		$Camera/Label.text = str(coins)
	elif coins >= 10:
		emit_signal("concluiu")

func _on_Notificador_screen_exited():
	emit_signal("morreu")


func _on_Moeda_body_entered(body):
	if body.name == "Player":
		_on_Player_pontua()


func _on_Hitbox_body_entered(body):
	pass
	

func die():
	$AnimationPlayer.play("dead")
	$Timer.start()


func _on_Timer_timeout():
	get_tree().reload_current_scene()
