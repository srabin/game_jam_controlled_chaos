extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout():
	#Can Add an if to skip this once minimum platform size is reached
	# also can add a counter like timouts_till_start that'll allow us to have different behaviors at different stages of game
	#ex: on first time out say "things are changing", on second timout "it's coming!", third timeout "things will start falling in 3.. 2... 1 .." etc. 
	var rect = self.get_used_rect()
	var new_rect = rect.grow(-2)
	print(rect)
	print(new_rect)
	var used_cells = get_used_cells()
	for cell in used_cells:
		if !new_rect.has_point(cell):
			erase_cell(cell)
	print("Scene Descreases!")
