extends Node

var tem_chave: bool = false
var pontos: int = 0
var vidas: int = 3

var musica_fundo: AudioStreamPlayer

func _ready():
	musica_fundo = AudioStreamPlayer.new()
	add_child(musica_fundo)
	
	musica_fundo.stream = preload("res://assets/Sounds/MusicTheme.mp3")
	musica_fundo.volume_db = -10 
	musica_fundo.play()
