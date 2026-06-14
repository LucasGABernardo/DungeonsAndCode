extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var colisor_fisico = $CollisionShape2D
@onready var area_interacao = $Area2D

var jogador_perto: bool = false
var porta_aberta: bool = false

func _ready():
	sprite.play("close")
	area_interacao.body_entered.connect(_on_body_entered)
	area_interacao.body_exited.connect(_on_body_exited)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("ação") and not porta_aberta:
		if Gerenciador.tem_chave:
			abrir_porta()
		else:
			print("A porta está trancada! Você precisa de uma chave.")

func _on_body_entered(body):
	if body is Player:
		jogador_perto = true

func _on_body_exited(body):
	if body is Player:
		jogador_perto = false

func abrir_porta():
	porta_aberta = true
	sprite.play("open") 
	
	colisor_fisico.disabled = true 
	Gerenciador.tem_chave = false 
	print("Porta aberta com sucesso!")
