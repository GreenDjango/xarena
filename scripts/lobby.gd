extends Control

var charaPanel : Panel
var charaBtn : Button

func _ready():
	charaPanel = $PlayerMenu
	charaBtn = $ButtonCharacter
	$ButtonClient.connect("pressed", self, "_start_client")
	$ButtonServer.connect("pressed", self, "_start_server")
	$Panel/ButtonBack.connect("pressed", self, "_remove_network")
	$Panel/ButtonPlay.connect("pressed", self, "_launch_game")
	charaBtn.connect("pressed", self, "_toggle_character_panel")
	GameNetwork.connect("players_update", self, "_on_players_update")
	GameNetwork.connect("server_close", self, "_on_server_close")

func _get_name() -> String:
	var name : String = $LineEdit.text if ($LineEdit.text) else "Player" + str (randi()%1000)
	return name

func _start_client():
	GameNetwork.start_client(_get_name())
	$Panel/ButtonPlay.text = "Wait..."
	$Panel/ButtonPlay.disabled = true
	_show_panel()

func _start_server():
	GameNetwork.start_server(_get_name())
	$Panel/ButtonPlay.text = "Play"
	$Panel/ButtonPlay.disabled = false
	_show_panel()

func _show_panel():
	$Panel/Label.text = "Awaiting Players..."
	$Panel/ItemList.clear()	
	$Panel/ItemList.add_item(str(GameNetwork.get_name()) + " (You)")
	$Panel.show()
	$ColorRect.show()

func _remove_network():
	$Panel.hide()
	$ColorRect.hide()
	GameNetwork.close()
	
func _toggle_character_panel():
	charaPanel.visible = !charaPanel.visible

func _on_players_update():
	$Panel/ItemList.clear()
	$Panel/ItemList.add_item(str(GameNetwork.get_name()) + " (You)")
	for i in GameNetwork.db_players:
		if (i != get_tree().get_network_unique_id()):
			$Panel/ItemList.add_item(str(GameNetwork.db_players[i].name))

func _on_server_close():
	$Panel/ItemList.clear()
	$Panel/Label.text = "Server close :("

func _launch_game():
	get_tree().change_scene("res://scenes/game.tscn")
