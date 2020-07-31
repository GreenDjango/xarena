extends Spatial

var _power : float = 0
export(float, 0, 1, 0.01) var power_step : float = 0.1
var _is_power_full := false
var _timer : Timer = null
var _time_label : Label = null
var _power_bar : TextureProgress = null
var _power_bar_particle : Particles2D = null

func _ready():
	_timer = $Timer
	_timer.start()
	_time_label = $Control/TimeRemaining
	_power_bar = $Control/PowerProgress
	_power_bar.min_value = 0
	_power_bar.max_value = 100
	_power_bar.value = 0
	_power_bar_particle = $Control/PowerProgress/FireParticles
	_power_bar_particle.emitting = false

func _process(_delta):
	var sec_left := int(ceil(int(_timer.time_left)%60))
	var sec_left_str := str(sec_left) if (sec_left >= 10) else '0' + str(sec_left)
	_time_label.text = str(int(_timer.time_left/60)) + ':' + sec_left_str

	if _power < 100:
		_power =  100.0 if (_power + power_step > 100) else _power + power_step
	_power_bar.value = int(_power)
	if !_is_power_full && _power == 100:
		_is_power_full = true
		_power_bar_particle.emitting = true
