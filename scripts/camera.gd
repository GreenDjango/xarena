extends Camera

export(NodePath) var target_path
export(float) var offset_x = 0
export(float) var offset_z = 1.85
export(float) var smoothness = 1
var _target : Spatial = null

func _ready():
	_target = get_node(target_path)
	pass

func _physics_process(delta):
	translation.x = move_toward( translation.x, _target.translation.x + offset_x, delta * smoothness)
	translation.z = move_toward( translation.z, _target.translation.z + offset_z, delta * smoothness)

func _process(delta):
	# --- DebugDraw ---
	var time = round(OS.get_ticks_msec() / 10.0) / 100.0
	var ram = round(OS.get_static_memory_usage() / 100000.0) / 10.0
	DebugDraw.set_text("Time", time)
	DebugDraw.set_text("FPS", Engine.get_frames_per_second())
	DebugDraw.set_text("Ram (MB)", ram)
	DebugDraw.set_text("delta", delta)
