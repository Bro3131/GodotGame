class_name MyHitBox

extends Area2D

@export var damage := 1

func _init():
	collision_layer= 2
	collision_mask = 0


@onready var animation_player = %Huy

func _ready():
	connect("body_entered", Callable (self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		give_damage()
		body.take_damage(1)

func give_damage():
	# Trigger animation here
	animation_player.play("hit")
