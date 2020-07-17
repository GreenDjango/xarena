extends Spatial

func _ready():
	$Timer.start()
	pass

func _process(delta):
	var sec_left : int = ceil(int($Timer.time_left)%60)
	var sec_left_str := str(sec_left) if (sec_left >= 10) else '0' + str(sec_left)
	$Control/TimeRemaining.text = str(int($Timer.time_left/60)) + ':' + sec_left_str
