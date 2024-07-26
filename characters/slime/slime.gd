extends Node2D

@onready var animation_player := $AnimationPlayer

func play_walk():
	%AnimationPlayer.play("walk")


func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")
	
func take_damage(amount: int):
	animation_player.play("hit")
	print("Damage: ", amount)
