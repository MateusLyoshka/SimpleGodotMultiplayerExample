extends Node2D

func _ready():
	Lobby.player_loaded.rpc_id(1)

func start_game():
	print("All players loaded, game starts!")
