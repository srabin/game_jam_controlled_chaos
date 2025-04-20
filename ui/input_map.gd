extends Button

@export var action : String
@onready var controls: Control = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode = true
	set_process_unhandled_input(false)
	update_text()



func _toggled(button_pressed) -> void:
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "Awaiting Input..."
		release_focus()
	else:
		update_text()
		grab_focus()
		
func _unhandled_input(event: InputEvent) -> void:

	if event.pressed:
		var events = InputMap.action_get_events(action)

		for input_pressed in events:
			if (input_pressed is not InputEventJoypadButton) and (input_pressed is not InputEventJoypadMotion):
				InputMap.action_erase_event(action, input_pressed)
		#InputMap.action_erase_events(action)
	
		InputMap.action_add_event(action, event)
		button_pressed = false
	
		
func update_text()-> void:
	var events = InputMap.action_get_events(action)
	for input_pressed in events:
		
		if (input_pressed is not InputEventJoypadButton) and (input_pressed is not InputEventJoypadMotion):
			text = input_pressed.as_text()
	
	#text = InputMap.action_get_events(action)[0].as_text()
