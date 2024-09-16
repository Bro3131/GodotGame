extends Node2D

#@onready var ui_scene_packed = preload("res://ui.tscn")
@onready var end_game_screen = $UIs/ui/EndGameScreen
@onready var main_menu = $UIs/ui/MainMenu
@onready var settings_menu = $UIs/ui/SettingsMenu
@onready var pause_menu = $UIs/ui/PauseMenu
@onready var time_label = $CanvasLayer/time
var elapsed_time # Переменная для отслеживания времени

func _ready():
	end_game_screen.visible = false
	main_menu.visible = false
	settings_menu.visible = false
#	pause_menu.visible = false
	get_tree().paused = false
	elapsed_time = 0.0

func _process(delta):
	elapsed_time += delta
	update_time_label()

# Обновляем текст Label с временем
func update_time_label():
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]


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


func _on_pause_button_pressed():
	pause_menu.visible = true
	get_tree().paused = true
