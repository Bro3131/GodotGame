class_name MyHurtBox
extends  Area2D

func _init():
	collision_layer= 0
	collision_mask = 2
	
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(hitbox: MyHitBox):
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage()
