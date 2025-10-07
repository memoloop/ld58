extends Node

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level1/level_1.tscn")

func _on_quit_button_button_down():
	get_tree().quit()