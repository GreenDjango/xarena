extends Node

var SERVER_PORT := 38660
var BACKLOG := 5
var SERVER_ID := 1
var db_players = {}
var _is_server := false setget ,is_server
signal players_update
signal server_close

func _ready():
	randomize()
	#get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_server_connected")
	get_tree().connect("connection_failed", self, "_on_server_close")
	get_tree().connect("server_disconnected", self, "_on_server_close")

# --- SERVER ---
func start_server(name : String):
	_is_server = true
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, BACKLOG)
	get_tree().network_peer = peer
	db_players[SERVER_ID] = {"name": name}

func is_server() -> bool:
	return _is_server

remote func register_player(player_name : String):
	var id = get_tree().get_rpc_sender_id()
	db_players[id] = {"name": player_name}
	emit_signal("players_update")
	rpc("player_list", db_players)

func _on_player_disconnected(id : int):
	if (!is_server() || id == SERVER_ID):
		return
	db_players.erase(id)
	emit_signal("players_update")

# --- CLIENT ---
func start_client(name : String):
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client("127.0.0.1", SERVER_PORT)
	get_tree().network_peer = peer
	db_players[get_tree().get_network_unique_id()] = {"name": name}

remote func player_list(new_list : Dictionary):
	db_players = new_list
	emit_signal("players_update")

func _on_server_connected():
	rpc_id(SERVER_ID, "register_player", get_name())

func _on_server_close():
	emit_signal("server_close")

# --- COMMON ---
func close():
	_is_server = false
	get_tree().network_peer = null
	db_players = {}
	
func get_name() -> String:
	return db_players[get_tree().get_network_unique_id()].name
