extends Area2D

@onready var sprite = $AnimatedSprite2D
var jogador_perto: bool = false
var bau_aberto: bool = false

func _ready():
	sprite.play("close")

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("ação") and not bau_aberto:
		abrir_bau()

func _on_body_entered(body):
	if body is Player:
		jogador_perto = true

func _on_body_exited(body):
	if body is Player:
		jogador_perto = false

func abrir_bau():
	bau_aberto = true
	sprite.play("open") 
	Gerenciador.tem_chave = true 
	print("Você conseguiu a chave!")
