extends Control

func _on_quit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UIs/main_menu.tscn")


func _on_pause_settings_pressed() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	self.visible = false
	get_tree().paused = false
