extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://testgame.tscn")


func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UIs/main_menu.tscn")
