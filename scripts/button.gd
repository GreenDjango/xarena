extends Button

export(String) var animation_name : String
var animPlayer : AnimationPlayer

func _ready():
	connect("button_down", self, "_on_down")
	connect("button_up", self, "_on_up")
	animPlayer = get_parent().get_node("AnimationPlayer")

func _on_down():
	animPlayer.play_backwards(animation_name)
	
func _on_up():
	animPlayer.queue(animation_name)
