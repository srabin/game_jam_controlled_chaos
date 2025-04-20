class_name AudioManager extends Node


@export_category("Omni")
## List of audios. Similar to AudioStreamPlayer
@export var audios_omni: Array[AudioMangerOmni] = []

@export_category("2D")
## Parent node of the node tree.
@export var target_parent_audios_2d: Node2D = null:
	set(value):
		target_parent_audios_2d = value
		if is_instance_valid(target_parent_audios_2d):
			for audio in audios_2d:
				var audio_controller = _get_audio_controller_2d(audio.audio_name)
				if is_instance_valid(audio_controller):
					if not audio_controller.is_inside_tree():
						target_parent_audios_2d.add_child(audio_controller)
					else:
						audio_controller.reparent(target_parent_audios_2d)
					audio_controller.position = Vector2.ZERO
## List of 2d audios. Similar to AudioStreamPlayer2D
@export var audios_2d: Array[AudioManger2D] = []

@export_category("3D")
## Parent node of the node tree.
@export var target_parent_audios_3d: Node3D = null:
	set(value):
		target_parent_audios_3d = value
		if is_instance_valid(target_parent_audios_3d):
			for audio in audios_3d:
				var audio_controller = _get_audio_controller_3d(audio.audio_name)
				if is_instance_valid(audio_controller):
					if not audio_controller.is_inside_tree():
						target_parent_audios_3d.add_child(audio_controller)
					else:
						audio_controller.reparent(target_parent_audios_3d)
					audio_controller.position = Vector3.ZERO
## List of 3d audios. Similar to AudioStreamPlayer3D
@export var audios_3d: Array[AudioManger3D] = []


var audios_manager_controller_omni: Dictionary = {}
var audios_manager_controller_2d: Dictionary = {}
var audios_manager_controller_3d: Dictionary = {}


func _ready() -> void:
	_init_audios_omni()
	_init_audios_2d()
	_init_audios_3d()
	pass


## Play audio Omni by name
func play_audio_omni(audio_name: String) -> void:
	var audio = _validate_audio_omni(audio_name)
	if not audio:
		return
		
	if not audio.is_inside_tree():
		return
		
	if float(audio.duration) <= 0.0:
		return

	var timer: Timer = _setup_timer_omni(audio_name)

	if audio.use_clipper:
		audio.play(audio.start_time)
	else:
		audio.play()

	timer.start()
	pass
	

## Play audio 2D by name
func play_audio_2d(audio_name: String) -> void:
	var audio = _validate_audio_2d(audio_name)
	if not audio:
		return
		
	if not audio.is_inside_tree():
		return
		
	if float(audio.duration) <= 0.0:
		return

	var timer: Timer = _setup_timer_2d(audio_name)
	var fade_timer: Timer = _setup_fade_timer_2d(audio_name)

	if audio.use_clipper:
		audio.play(audio.start_time)
	else:
		audio.play()

	timer.start()
	fade_timer.start()
	pass
	
	
## Play audio 3D by name
func play_audio_3d(audio_name: String) -> void:
	var audio = _validate_audio_3d(audio_name)
	if not audio:
		return
		
	if not audio.is_inside_tree():
		return
		
	if float(audio.duration) <= 0.0:
		return

	var timer: Timer = _setup_timer_3d(audio_name)

	if audio.use_clipper:
		audio.play(audio.start_time)
	else:
		audio.play()

	timer.start()
	pass


## Pause audio Omni by name
func pause_audio_omni(audio_name: String) -> void:
	var audio = _validate_audio_omni(audio_name)
	if not audio or audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_omni(audio_name)
	audio.stream_paused = true
	audio.time_remain = timer.time_left
	timer.stop()
	pass
	

## Pause audio 2D by name
func pause_audio_2d(audio_name: String) -> void:
	var audio = _validate_audio_2d(audio_name)
	if not audio or audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_2d(audio_name)
	audio.stream_paused = true
	audio.time_remain = timer.time_left
	timer.stop()
	pass
	
	
## Pause audio 3D by name
func pause_audio_3d(audio_name: String) -> void:
	var audio = _validate_audio_3d(audio_name)
	if not audio or audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_3d(audio_name)
	audio.stream_paused = true
	audio.time_remain = timer.time_left
	timer.stop()
	pass


## Continue audio Omni by name
func continue_audio_omni(audio_name: String) -> void:
	var audio = _validate_audio_omni(audio_name)
	if not audio or not audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_omni(audio_name)
	audio.stream_paused = false
	timer.start(audio.time_remain)
	pass
	
	
## Continue audio 2D by name
func continue_audio_2d(audio_name: String) -> void:
	var audio = _validate_audio_2d(audio_name)
	if not audio or not audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_2d(audio_name)
	audio.stream_paused = false
	timer.start(audio.time_remain)
	pass


## Continue audio 3D by name
func continue_audio_3d(audio_name: String) -> void:
	var audio = _validate_audio_3d(audio_name)
	if not audio or not audio.stream_paused:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_3d(audio_name)
	audio.stream_paused = false
	timer.start(audio.time_remain)
	pass
	

## Stop audio Omni by name
func stop_audio_omni(audio_name: String) -> void:
	var audio = _validate_audio_omni(audio_name)
	if not audio or not audio.playing:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_omni(audio_name)
	
	timer.stop()
	audio.stop()
	pass


## Stop audio 2D by name
func stop_audio_2d(audio_name: String) -> void:
	var audio = _validate_audio_2d(audio_name)
	if not audio or not audio.playing:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_2d(audio_name)
	
	timer.stop()
	audio.stop()
	pass
	

## Stop audio 3D by name
func stop_audio_3d(audio_name: String) -> void:
	var audio = _validate_audio_3d(audio_name)
	if not audio or not audio.playing:
		return
		
	if not audio.is_inside_tree():
		return
	
	var timer: Timer = _setup_timer_3d(audio_name)
	
	timer.stop()
	audio.stop()
	pass
	

## Play all audios
func play_all() -> void:
	for a in audios_omni:
		play_audio_omni(a.audio_name)
		
	for a in audios_2d:
		play_audio_2d(a.audio_name)
		
	for a in audios_3d:
		play_audio_3d(a.audio_name)
	pass


## Play all audios omni
func play_all_omni() -> void:
	for a in audios_omni:
		play_audio_omni(a.audio_name)
	pass


## Play all audios 2D
func play_all_2d() -> void:
	for a in audios_2d:
		play_audio_2d(a.audio_name)
	pass


## Play all audios 3D
func play_all_3d() -> void:
	for a in audios_3d:
		play_audio_3d(a.audio_name)
	pass


## Stop all audios
func stop_all() -> void:
	for a in audios_omni:
		stop_audio_omni(a.audio_name)
		
	for a in audios_2d:
		stop_audio_2d(a.audio_name)
		
	for a in audios_3d:
		stop_audio_3d(a.audio_name)
	pass


## Stop all audios Omni
func stop_all_omni() -> void:
	for a in audios_omni:
		stop_audio_omni(a.audio_name)
	pass


## Stop all audios 2D
func stop_all_2d() -> void:
	for a in audios_2d:
		stop_audio_2d(a.audio_name)
	pass


## Stop all audios
func stop_all_3d() -> void:
	for a in audios_3d:
		stop_audio_3d(a.audio_name)
	pass


## Pause all audios
func pause_all() -> void:
	for a in audios_omni:
		pause_audio_omni(a.audio_name)
	
	for a in audios_2d:
		pause_audio_2d(a.audio_name)
	
	for a in audios_3d:
		pause_audio_3d(a.audio_name)
	pass


## Pause all audios Omni
func pause_all_omni() -> void:
	for a in audios_omni:
		pause_audio_omni(a.audio_name)
	pass


## Pause all audios
func pause_all_2d() -> void:
	for a in audios_2d:
		pause_audio_2d(a.audio_name)
	pass


## Pause all audios
func pause_all_3d() -> void:
	for a in audios_3d:
		pause_audio_3d(a.audio_name)
	pass


## Continue all audios
func continue_all() -> void:
	for a in audios_omni:
		continue_audio_omni(a.audio_name)
		
	for a in audios_2d:
		continue_audio_2d(a.audio_name)
		
	for a in audios_3d:
		continue_audio_3d(a.audio_name)
	pass


## Continue all audios Omni
func continue_all_omni() -> void:
	for a in audios_omni:
		continue_audio_omni(a.audio_name)
	pass


## Continue all audios
func continue_all_2d() -> void:
	for a in audios_2d:
		continue_audio_2d(a.audio_name)
	pass


## Continue all audios
func continue_all_3d() -> void:
	for a in audios_3d:
		continue_audio_3d(a.audio_name)
	pass


## Get audio 3D (AudioManger3D)
func get_audio_3d(_audio_name: String) -> AudioManger3D:
	for aud in audios_3d:
		if aud.audio_name == _audio_name:
			return aud
	push_warning("AudioManger3D %s not find."%_audio_name)
	return null
	
	
## Get audio Omni (AudioMangerOmni)
func get_audio_omni(_audio_name: String) -> AudioMangerOmni:
	for aud in audios_omni:
		if aud.audio_name == _audio_name:
			return aud
	push_warning("AudioMangerOmni %s not find."%_audio_name)
	return null
	
	
## Get audio 2D (AudioManger2D)
func get_audio_2d(_audio_name: String) -> AudioManger2D:
	for aud in audios_2d:
		if aud.audio_name == _audio_name:
			return aud
	push_warning("AudioManger2D %s not find."%_audio_name)
	return null


## Init audios instances
func _init_audios_omni() -> void:
	for audio_omni in audios_omni:
		if not _check_audio(audio_omni):
			continue
		_warning_audio(audio_omni)

		var new_audio_manager_controller_omni: AudioManagerControllerOmni = AudioManagerControllerOmni.new(
			audio_omni.start_time, audio_omni.duration, audio_omni.use_clipper, audio_omni.loop, 0.0, false
			)
		
		audio_omni._owner = new_audio_manager_controller_omni
		_setup_audio_properties_omni(new_audio_manager_controller_omni, audio_omni)
		audios_manager_controller_omni[audio_omni.audio_name] = new_audio_manager_controller_omni
		add_child(new_audio_manager_controller_omni)

		if audio_omni.duration > 0 and audio_omni.auto_play:
			play_audio_omni.call_deferred(audio_omni.audio_name)
	pass


func _init_audios_2d() -> void:
	for audio_2d in audios_2d:
		if not _check_audio(audio_2d):
			continue
		_warning_audio(audio_2d)

		var new_audio_manager_controller_2d: AudioManagerController2D = AudioManagerController2D.new(
			audio_2d.start_time, audio_2d.duration, audio_2d.use_clipper, audio_2d.loop, 0.0, false, audio_2d.fade_time, false
			)
		
		audio_2d._owner = new_audio_manager_controller_2d
		_setup_audio_properties_2d(new_audio_manager_controller_2d, audio_2d)
		audios_manager_controller_2d[audio_2d.audio_name] = new_audio_manager_controller_2d
		
		if is_instance_valid(target_parent_audios_2d):
			target_parent_audios_2d.add_child.call_deferred(new_audio_manager_controller_2d)
		else:
			if get_parent():
				get_parent().call_deferred("add_child", new_audio_manager_controller_2d)
			else:
				add_child(new_audio_manager_controller_2d)
		
		if audio_2d.duration > 0 and audio_2d.auto_play:
			call_deferred("play_audio_2d", audio_2d.audio_name)
	pass
	
	
func _init_audios_3d() -> void:
	for audio_3d in audios_3d:
		if not _check_audio(audio_3d):
			continue
		_warning_audio(audio_3d)

		var new_audio_manager_controller_3d: AudioManagerController3D = AudioManagerController3D.new(
			audio_3d.start_time, audio_3d.duration, audio_3d.use_clipper, audio_3d.loop, 0.0, false
			)
		
		audio_3d._owner = new_audio_manager_controller_3d
		
		_setup_audio_properties_3d(new_audio_manager_controller_3d, audio_3d)
		audios_manager_controller_3d[audio_3d.audio_name] = new_audio_manager_controller_3d
		
		if is_instance_valid(target_parent_audios_3d):
			target_parent_audios_3d.add_child.call_deferred(new_audio_manager_controller_3d)
		else:
			if get_parent():
				get_parent().add_child.call_deferred(new_audio_manager_controller_3d)
			else:
				add_child(new_audio_manager_controller_3d)

		if audio_3d.duration > 0 and audio_3d.auto_play:
			play_audio_3d.call_deferred(audio_3d.audio_name)
	pass
	
	
func _setup_audio_properties_omni(audio: AudioStreamPlayer, a: AudioMangerOmni) -> void:
	audio.stream = a.audio_stream
	audio.volume_db = a.volume_db
	audio.pitch_scale = a.pitch_scale
	audio.mix_target = a.mix_target
	audio.max_polyphony = a.max_polyphony
	pass
	

func _setup_audio_properties_2d(audio: AudioStreamPlayer2D, a: AudioManger2D) -> void:
	audio.stream = a.audio_stream
	audio.volume_db = a.volume_db
	audio.pitch_scale = a.pitch_scale
	audio.max_distance = a.max_distance
	audio.max_polyphony = a.max_polyphony
	audio.panning_strength = a.panning_strength
	pass


func _setup_audio_properties_3d(audio: AudioStreamPlayer3D, a: AudioManger3D) -> void:
	audio.stream = a.audio_stream
	audio.volume_db = a.volume_db
	audio.max_db = a.max_db
	audio.pitch_scale = a.pitch_scale
	audio.max_distance = a.max_distance
	audio.unit_size = a.unit_size
	audio.max_polyphony = a.max_polyphony
	audio.panning_strength = a.panning_strength
	pass
	

func _validate_audio_3d(_audio_name: String) -> AudioManagerController3D:
	var audio = _get_audio_controller_3d(_audio_name)
	if not audio:
		push_warning("AudioManger3D name (%s) not found." % _audio_name)
	return audio
	
	
func _validate_audio_omni(_audio_name: String) -> AudioManagerControllerOmni:
	var audio = _get_audio_controller_omni(_audio_name)
	if not audio:
		push_warning("AudioMangerOmni name (%s) not found." % _audio_name)
	return audio
	
	
func _validate_audio_2d(_audio_name: String) -> AudioManagerController2D:
	var audio = _get_audio_controller_2d(_audio_name)
	if not audio:
		push_warning("AudioManger2D name (%s) not found." % _audio_name)
	return audio


func _setup_timer_omni(_audio_name: String) -> Timer:
	var audio = _get_audio_controller_omni(_audio_name) as AudioManagerControllerOmni
	audio.timer.one_shot = not audio.loop
	audio.timer.wait_time = max(audio.duration, 0.00001)
	if not audio.is_timer_connected:
		audio.timer.timeout.connect(Callable(_on_timer_timeout_omni).bind(audio, _audio_name, func(): play_audio_omni(_audio_name)))
		audio.is_timer_connected = true
	return audio.timer
	

func _setup_timer_2d(_audio_name: String) -> Timer:
	var audio = _get_audio_controller_2d(_audio_name) as AudioManagerController2D
	audio.timer.one_shot = not audio.loop
	audio.timer.wait_time = max(audio.duration, 0.00001)
	if not audio.is_timer_connected and not audio.fade_time > 0.0:
		audio.timer.timeout.connect(Callable(_on_timer_timeout_2d).bind(audio, _audio_name, func(): play_audio_2d(_audio_name)))
		audio.is_timer_connected = true
	return audio.timer

func _setup_fade_timer_2d(_audio_name: String) -> Timer:
	var audio = _get_audio_controller_2d(_audio_name) as AudioManagerController2D
	audio.fade_timer.one_shot = not audio.loop
	audio.fade_timer.wait_time = max(audio.fade_time, 0.00001)
	if not audio.is_fade_timer_connected:
		audio.fade_timer.timeout.connect(Callable(_on_timer_timeout_2d).bind(audio, _audio_name, func(): play_audio_2d(_audio_name)))
		audio.is_fade_timer_connected = true
	return audio.fade_timer

func _setup_timer_3d(_audio_name: String) -> Timer:
	var audio = _get_audio_controller_3d(_audio_name) as AudioManagerController3D
	audio.timer.one_shot = not audio.loop
	audio.timer.wait_time = max(audio.duration, 0.00001)
	if not audio.is_timer_connected:
		audio.timer.timeout.connect(Callable(_on_timer_timeout_3d).bind(audio, _audio_name, func(): play_audio_3d(_audio_name)))
		audio.is_timer_connected = true
	return audio.timer


func _on_timer_timeout_omni(_audio: AudioManagerControllerOmni, _audio_name: String, cb: Callable) -> void:
	if _audio.loop:
		cb.call()
	else:
		_audio.stop()
	pass


func _on_timer_timeout_2d(_audio: AudioManagerController2D, _audio_name: String, cb: Callable) -> void:
	if _audio.loop:
		cb.call()
	else:
		_audio.stop()
	pass
	
	
func _on_timer_timeout_3d(_audio: AudioManagerController3D, _audio_name: String, cb: Callable) -> void:
	if _audio.loop:
		cb.call()
	else:
		_audio.stop()
	pass


func _get_audio_controller_omni(_audio_name: String) -> AudioManagerControllerOmni:
	return audios_manager_controller_omni.get(_audio_name, null) as AudioManagerControllerOmni


func _get_audio_controller_2d(_audio_name: String) -> AudioManagerController2D:
	return audios_manager_controller_2d.get(_audio_name, null) as AudioManagerController2D


func _get_audio_controller_3d(_audio_name: String) -> AudioManagerController3D:
	return audios_manager_controller_3d.get(_audio_name, null) as AudioManagerController3D


func _warning_audio(_audio: Variant) -> void:
	if not _audio.audio_stream:
		push_warning("The STREAM property cannot be null. (%s)" % _audio.audio_name)
	if _audio.duration <= 0.0:
		push_warning("AudioManger duration cannot be less than or equal to zero. Check START_TIME, END_TIME. (%s)" % _audio.audio_name)
	if _audio.use_clipper and _audio.start_time > _audio.end_time:
		push_warning("Start time cannot be greater than end time in AudioManger resource: (%s)" % _audio.audio_name)
	pass
	
	
func _check_audio(_audio: Variant) -> bool:
	if not _audio or not _audio.audio_stream:
		push_warning("AudioManger resource or its stream is not properly defined.")
		return false
	if _audio.start_time > _audio.end_time:
		push_warning("AudioManger start time cannot be greater than end time for '%s'. AudioMangerResource deleted from ManagerList." % _audio.audio_name)
		return false
	return true
	
	
#*****************************************************************************
class AudioManagerControllerOmni extends AudioStreamPlayer:
	var timer: Timer
	var start_time: float
	var duration: float
	var use_clipper: bool
	var loop: bool:
		set(value):
			loop = value
			if (!loop and !timer.is_stopped()):
				timer.stop()
		
	var time_remain: float
	var is_timer_connected: bool
	
	func _init(_start_time: float, _duration: float, _use_clipper: bool, _loop: bool, _time_remain: float, _is_timer_connected: bool) -> void:
		timer = Timer.new()
		timer.name = "timer"
		add_child(timer)
		
		self.start_time = _start_time
		self.duration = _duration
		self.use_clipper = _use_clipper
		self.loop = _loop
		self.time_remain = _time_remain
		self.is_timer_connected = _is_timer_connected
		pass
		
		
#*****************************************************************************
class AudioManagerController2D extends AudioStreamPlayer2D:
	var timer: Timer
	var start_time: float
	var fade_timer: Timer
	var fade_time: float
	var duration: float
	var use_clipper: bool
	var loop: bool:
		set(value):
			loop = value
			if (!loop and !timer.is_stopped()):
				timer.stop()
		
	var time_remain: float
	var is_timer_connected: bool
	var is_fade_timer_connected:bool
	pass

	func _init(_start_time: float, _duration: float, _use_clipper: bool, _loop: bool, _time_remain: float, _is_timer_connected: bool, _fade_time: float, _is_fade_timer_connected: bool) -> void:
		timer = Timer.new()
		timer.name = "timer"
		add_child(timer)
		
		fade_timer = Timer.new()
		fade_timer.name = "fade_timer"
		add_child(fade_timer)
		
		self.start_time = _start_time
		self.fade_time = _fade_time
		self.duration = _duration
		self.use_clipper = _use_clipper
		self.loop = _loop
		self.time_remain = _time_remain
		self.is_timer_connected = _is_timer_connected
		self.is_fade_timer_connected = _is_fade_timer_connected
		pass
		

#*******************************************************************
class AudioManagerController3D extends AudioStreamPlayer3D:
	var timer: Timer
	var start_time: float
	var duration: float
	var use_clipper: bool
	var loop: bool:
		set(value):
			loop = value
			if (!loop and !timer.is_stopped()):
				timer.stop()
		
	var time_remain: float
	var is_timer_connected: bool
	
	func _init(_start_time: float, _duration: float, _use_clipper: bool, _loop: bool, _time_remain: float, _is_timer_connected: bool) -> void:
		timer = Timer.new()
		timer.name = "timer"
		add_child(timer)
		
		self.start_time = _start_time
		self.duration = _duration
		self.use_clipper = _use_clipper
		self.loop = _loop
		self.time_remain = _time_remain
		self.is_timer_connected = _is_timer_connected
		pass
