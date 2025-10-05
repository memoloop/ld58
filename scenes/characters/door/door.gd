extends Area2D
class_name Door

@export_file("*.tscn") var next_level

func _on_body_entered(body: Node2D):
    if body is Player:
        get_tree().call_deferred("change_scene_to_file", next_level)