extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	
func spawn_player(id: int):
	if !multiplayer.is_server(): return
	var p = network_player.instantiate()
	p.name = str(id)
	get_node(spawn_path).call_deferred("add_child", p)
