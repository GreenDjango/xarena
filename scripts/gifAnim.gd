extends TextureRect

export(int) var size_x : int = 1
export(int) var size_y : int = 1
export(int, 1, 100) var frame_par_sec : int = 1 setget frame_par_sec_set
var _speed : float = 0.1
var _frame : int = 0
var _frame_size : Vector2
var _frame_max : int = 0
var _temp_elapsed : float = 0 

func _ready():
	_frame_max = size_x * size_y
	_frame_size = texture.region.size

func _process(delta):
	_temp_elapsed += delta
	while (_temp_elapsed >= _speed):
		_temp_elapsed -= _speed
		_frame += 1
		if (_frame >= _frame_max):
			_frame = 0
# warning-ignore:integer_division
		texture.region.position = Vector2(int(_frame%size_x)*_frame_size.x, int(_frame/size_x)*_frame_size.y)

func frame_par_sec_set(new_value : int):
	_speed = (1.0/new_value)
