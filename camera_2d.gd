extends Camera2D

@onready var player: CharacterBody2D = $"../Player"
#@onready var player_2: CharacterBody2D = $"../Player2"


func _process(delta):
	# Set camera position to be the center between the two players! 
	#self.global_position = (player.global_position + player_2.global_position) * 0.5
##	
	#var zoom_factor_x = abs(player.global_position.x-player_2.global_position.x)
	#var zoom_factor_y = abs(player.global_position.y-player_2.global_position.y)
	
	#TODO: tweak 500, as well as the upper/lower bounds of the zoomfactor
	#var max_zoom_factor = 500/max(zoom_factor_x, zoom_factor_y) 
#
	##print((max_zoom_factor))
	#var zoom_factor = clamp(max_zoom_factor, 0.5,1.5)
##
	#self.zoom = Vector2(zoom_factor, zoom_factor)
	
	pass
