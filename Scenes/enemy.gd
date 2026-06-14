extends CharacterBody2D

const SPEED = 70.0
var vida = 4
var vivo = true
var dir_inimigo = "down" 
var tomando_dano = false

var player: Player = null
var player_no_alcance_ataque = false

@onready var sprite = $AnimatedSprite2D
@onready var area_deteccao = $Detection
@onready var area_ataque = $Attack
@onready var som_dano_inimigo = $SomDanoInimigo
@onready var som_morte_inimigo = $SomMorteInimigo

func _ready():
	sprite.play("idle-down")
	area_deteccao.body_entered.connect(_on_player_detectado)
	area_deteccao.body_exited.connect(_on_player_perdi_de_vista)
	area_ataque.body_entered.connect(_on_player_entrou_ataque)
	area_ataque.body_exited.connect(_on_player_saiu_ataque)

func _physics_process(_delta):
	if not vivo or tomando_dano: return
		
	if player != null:
		var direcao = (player.global_position - global_position).normalized()
		velocity = direcao * SPEED
		
		# --- DEFINE A DIREÇÃO DO INIMIGO ---
		if abs(direcao.x) > abs(direcao.y):
			dir_inimigo = "right" if direcao.x > 0 else "left"
		else:
			dir_inimigo = "down" if direcao.y > 0 else "up"
		
		# Se estiver colado, ataca. Se não, anda!
		if player_no_alcance_ataque:
			velocity = Vector2.ZERO
			atacar_player()
		else:
			sprite.play("walk-" + dir_inimigo)
			move_and_slide()
	else:
		velocity = Vector2.ZERO
		sprite.play("idle-" + dir_inimigo)

func _on_player_detectado(body):
	if body is Player: player = body

func _on_player_perdi_de_vista(body):
	if body == player: player = null

func _on_player_entrou_ataque(body):
	if body is Player: player_no_alcance_ataque = true

func _on_player_saiu_ataque(body):
	if body is Player: player_no_alcance_ataque = false

# --- ATAQUE DO INIMIGO ---
var tempo_ultimo_ataque = 0.0
const COOLDOWN_ATAQUE = 1.2

func atacar_player():
	var tempo_atual = Time.get_ticks_msec() / 1000.0
	sprite.play("attack-" + dir_inimigo) 
	
	if tempo_atual - tempo_ultimo_ataque >= COOLDOWN_ATAQUE:
		tempo_ultimo_ataque = tempo_atual
		if player.has_method("receber_dano"):
			player.receber_dano(1)

# --- DANOS E MORTE ---
func receber_dano(quantidade):
	if not vivo: return
	vida -= quantidade
	
	if vida <= 0:
		morrer()
	else:
		som_dano_inimigo.play()
		tomando_dano = true
		velocity = Vector2.ZERO 
		sprite.play("damage-" + dir_inimigo)
		
		await sprite.animation_finished 
		tomando_dano = false

func morrer():
	vivo = false
	velocity = Vector2.ZERO
	
	som_morte_inimigo.play()
	sprite.play("death-" + dir_inimigo)
	
	Gerenciador.pontos += 1
	await sprite.animation_finished
	queue_free()
