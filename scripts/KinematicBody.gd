extends KinematicBody

export(NodePath) var sprite_path
var velocity = Vector3.ZERO
const speed_max = 200
var acceleration = 0
const acceleration_step = 0.1
const friction = 40
var last_fps = 0
var sprite_to_use: AnimatedSprite3D = null

func _ready():
	sprite_to_use = get_node(sprite_path)
	set_physics_process(true)
	set_as_toplevel(true)
	pass # Replace with function body.

func _physics_process(delta):
	#if last_fps != Performance.get_monitor(Performance.TIME_FPS):
	#	last_fps = Performance.get_monitor(Performance.TIME_FPS)
	#	OS.set_window_title("Zappy - " + str(last_fps) + " fps")
	var input = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		input.x += speed_max
	if Input.is_action_pressed("ui_left"):
		input.x -= speed_max
	if Input.is_action_pressed("ui_down"):
		input.z += speed_max
	if Input.is_action_pressed("ui_up"):
		input.z -= speed_max
	if input != Vector3.ZERO:
		if acceleration < 1:
			acceleration += acceleration_step
		velocity = input * delta * acceleration
		sprite_to_use.play("run")
		if velocity.x > 0:
			sprite_to_use.flip_h = false
		elif velocity.x < 0:
			sprite_to_use.flip_h = true
	else:
		acceleration = 0
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		sprite_to_use.play("idle")
	move_and_slide(velocity);
	#var collide = move_and_collide(velocity, true, true, true)
	#if collide:
	#	print(collide.collider_id)
