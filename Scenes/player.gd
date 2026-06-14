extends CharacterBody2D

class_name Player

const SPEED = 150
var dir = "down"
var atacando = false
var tomando_dano = false
var invencivel = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_ataque_player = $AttackPlayer
@onready var colisor_ataque = $AttackPlayer/CollisionShape2D

func _ready():
	colisor_ataque.disabled = true
	area_ataque_player.body_entered.connect(_on_espada_body_entered)

func _physics_process(_delta: float) -> void:
	if atacando or tomando_dano: return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide() 
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			dir = "right" if direction.x > 0 else "left"
		else:
			dir = "down" if direction.y > 0 else "up"
			
	# --- SISTEMA DE POSIÇÃO DA ESPADA ---
	# Move a área de ataque para frente do player com base na direção
	match dir:
		"right": area_ataque_player.position = Vector2(20, 0)
		"left": area_ataque_player.position = Vector2(-20, 0)
		"down": area_ataque_player.position = Vector2(0, 20)
		"up": area_ataque_player.position = Vector2(0, -20)

	# --- COMANDO DE ATAQUE ---
	if Input.is_action_just_pressed("ataque"):
		atacar()
		return

	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle-" + dir)
	else:
		animated_sprite_2d.play("walk-" + dir)

func atacar():
	atacando = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("attack-" + dir)
	
	colisor_ataque.disabled = false 
	
	# Espera a animação de ataque terminar
	await animated_sprite_2d.animation_finished
	
	colisor_ataque.disabled = true 
	atacando = false

# --- SE A ESPADA ENCOSTAR EM ALGUÉM ---
func _on_espada_body_entered(body):
	if body.has_method("receber_dano") and body != self:
		body.receber_dano(1) 

# --- DANOS E MORTE DO PLAYER ---
func receber_dano(quantidade):
	if invencivel or atacando or tomando_dano: return 
	
	Gerenciador.vidas -= quantidade
	
	if Gerenciador.vidas <= 0:
		morrer()
	else:
		tomando_dano = true
		invencivel = true
		velocity = Vector2.ZERO
		
		animated_sprite_2d.play("damage-" + dir)
		
		await animated_sprite_2d.animation_finished
		
		tomando_dano = false
		
		await get_tree().create_timer(0.2).timeout
		invencivel = false

func morrer():
	set_physics_process(false)
	animated_sprite_2d.play("death-" + dir)
	print("Game Over definitivo")
	
	await animated_sprite_2d.animation_finished
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
