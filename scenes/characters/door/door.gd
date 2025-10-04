extends Area2D
class_name Door

func _on_body_entered(body: Node2D):
    if body is Player:
        # TODO: go to the next level
        pass