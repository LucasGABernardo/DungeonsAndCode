extends CanvasLayer

@onready var label_pontos = $Control/Label_points
@onready var label_chave = $Control/Label_key
@onready var container_vidas = $Control/Life

var textura_vida = preload("res://assets/Player/PNG/Swordsman_lvl3/Swordsman_lvl3_Idle_head.PNG")

func _process(_delta: float) -> void:
	label_pontos.text = "Inimigos: " + str(Gerenciador.pontos)
	
	if Gerenciador.tem_chave:
		label_chave.text = "Chave: Sim 🔑"
	else:
		label_chave.text = "Chave: Não ❌"
	
	atualizar_vidas_visuais()

func atualizar_vidas_visuais():
	if container_vidas.get_child_count() != Gerenciador.vidas:
		for child in container_vidas.get_children():
			child.queue_free()
		
		for i in range(Gerenciador.vidas):
			var icone = TextureRect.new()
			icone.texture = textura_vida
			icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icone.custom_minimum_size = Vector2(60, 60) 
			container_vidas.add_child(icone)
