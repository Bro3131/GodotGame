class_name MyHitBox

extends Area2D

@export var damage := 1

func _init():
	collision_layer= 2
	collision_mask = 0

@onready var animation_player = %Huy
#func _physics_process(delta):
	#var enemies_in_range = get_overlapping_bodies()
	#if enemies_in_range.size() > 0:
		#var target_enemy = enemies_in_range[0]
		#look_at(target_enemy.global_position)


func _ready():
	connect("body_entered", Callable (self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print("Enemy hit")
		give_damage()
		body.take_damage()

func give_damage():
	# Trigger animation here
	animation_player.play("hit")

#
#func _on_timer_timeout():
	#animation_player.play("hit")
