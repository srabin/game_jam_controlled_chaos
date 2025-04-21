extends Node
var chaos: float
var select_beep: AudioStreamPlayer
var select_click: AudioStreamPlayer
var title_track: AudioStreamPlayer
var fight_track: AudioStreamPlayer
var end_track: AudioStreamPlayer

func _on_fight_track_finished():
	fight_track.play(100.063)

func _on_title_track_finished():
	title_track.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_beep = AudioStreamPlayer.new()
	var select_beep_stream = load("res://sounds/select_click.wav")
	select_beep.set_stream(select_beep_stream)
	select_beep.pitch_scale = 0.75
	select_beep.name = "SelectBeep"
	select_beep.bus = "SFX"
	add_child(select_beep)
	
	select_click = AudioStreamPlayer.new()
	var select_click_stream = load("res://sounds/select_click.wav")
	select_click.set_stream(select_click_stream)
	select_click.name = "SelectClick"
	select_click.bus = "SFX"
	add_child(select_click)
	
	title_track = AudioStreamPlayer.new()
	var title_track_stream = load("res://sounds/title_track.wav")
	title_track.set_stream(title_track_stream)
	title_track.name = "TitleTrack"
	title_track.bus = "Music"
	title_track.finished.connect(_on_title_track_finished)
	add_child(title_track)
	
	fight_track = AudioStreamPlayer.new()
	var fight_track_stream = load("res://sounds/fight_track.wav")
	fight_track.set_stream(fight_track_stream)
	fight_track.name = "FightTrack"
	fight_track.bus = "Music"
	fight_track.finished.connect(_on_fight_track_finished)
	add_child(fight_track)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
