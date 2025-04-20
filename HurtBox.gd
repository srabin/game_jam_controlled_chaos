class_name HurtBox
extends Area2D

@export var damage := 10

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage") and owner != hitbox.owner:
		var direction = hitbox.owner.position.direction_to(self.owner.position)
		owner.take_damage(hitbox.damage, direction, hitbox.owner)
