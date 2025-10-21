extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var ip_input = $VBoxContainer/IPInput
@onready var host_button = $VBoxContainer/HostButton
@onready var join_button = $VBoxContainer/JoinButton
@onready var start_button = $VBoxContainer/StartButton

func _ready():
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	
func _on_player_connected(id, info):
	print("Player connected:", id, info)

func _on_player_disconnected(id):
	print("Player disconnected:", id)

func _on_host_button_pressed() -> void:
	Lobby.player_info.name = name_input.text
	Lobby.create_server()

func _on_join_button_pressed() -> void:
	Lobby.player_info.name = name_input.text
	Lobby.join_server(ip_input.text)

func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		Lobby.load_game.rpc("res://high_level_example_2/scenes/Game.tscn")
