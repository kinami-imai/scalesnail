extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.gravity_scale = 0.1
		body.linear_damp = 5


func _on_body_exited(body):
	if body.name == "Player":
		body.gravity_scale = 1
		body.linear_damp = 0
