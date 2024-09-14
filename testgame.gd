extends Node2D

@onready var ui_scene_packed = preload("res://ui.tscn")
@onready var end_game_screen
@onready var main_menu
@onready var settings_menu


func _ready():
	var ui_scene = ui_scene_packed.instantiate()
	add_child(ui_scene)
	var ui_node = ui_scene.get_node("ui")
	end_game_screen = ui_node.get_node("EndGameScreen")
	end_game_screen.visible = false
	main_menu = ui_node.get_node("MainMenu")
	main_menu.visible = false
	settings_menu = ui_node.get_node("SettingsMenu")
	settings_menu.visible = false
	get_tree().paused = false


func spawn_mob():
	var new_mob = preload("res://mobtest.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_gone():
	end_game_screen.visible = true
	get_tree().paused = true



func _on_mobspawn_timer_timeout():
	pass # Replace with function body.
