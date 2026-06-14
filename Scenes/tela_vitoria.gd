extends Control

@onready var label_pontos = $Label_points

func _ready():
	label_pontos.text = "Inimigos derrotados: " + str(Gerenciador.pontos)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed() -> void:
	Gerenciador.vidas = 3
	Gerenciador.pontos = 0
	Gerenciador.tem_chave = false
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
