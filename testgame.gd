extends Node2D


@onready var pause_menu: Control = $PauseMenu/Pause_menu
@onready var time_label: Label = $stuff/time


var elapsed_time # Переменная для отслеживания времени

func _ready():
	pause_menu.visible = false
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
	var new_mob = preload("res://Enemy/mobtest.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_gone():
	get_tree().change_scene_to_file("res://UIs/end_game_screen.tscn")


func _on_mobspawn_timer_timeout():
	pass # Replace with function body.


#Pause
func _on_pause_button_pressed():
	pause_menu.visible = true
	get_tree().paused = true


func _on_continue_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UIs/main_menu.tscn")
