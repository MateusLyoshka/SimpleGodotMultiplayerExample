extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const DEFAULT_IP = "127.0.0.1"
const MAX_CONNECTIONS = 20

var players := {}        # Dicionário { peer_id: {name, ...} }
var player_info := {"name": "Player"}  # Info local antes de conectar
var players_loaded := 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connected_fail)
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT, MAX_CONNECTIONS)
	if err != OK:
		push_error("failed to create server: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	players[1] = player_info
	print("host name: %s" %player_info)
	
func join_server(address := ""):
	if address.is_empty(): address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(address, PORT)
	if err != OK:
		push_error("Failed to connect: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	
func disconnected():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	
# SCENE LOADING

@rpc("call_local", "reliable")
func load_game(scene_path:String):
	get_tree().change_scene_to_file(scene_path)
	
@rpc("any_peer","call_local","reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0
			
# PLAYER CONNECTION LOGIC

func _on_player_connected(id: int):
	if multiplayer.is_server():
		_register_player.rpc_id(id, player_info)
		
	
@rpc("any_peer","reliable")
func _register_player(new_player_info: Dictionary):
	print(multiplayer.get_unique_id(), " recebeu info de ", multiplayer.get_remote_sender_id(), ": ", new_player_info)
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_info
	player_connected.emit(id, new_player_info)

func _on_player_disconnected(id:int):
	players.erase(id)
	player_disconnected.emit(id)
	
func _on_connected_ok():
	var id = multiplayer.get_unique_id()
	players[id] = player_info
	#player_connected.emit(id, player_info)

func _on_connected_fail():
	disconnected()

func _on_server_disconnected():
	disconnected()
	server_disconnected.emit()
