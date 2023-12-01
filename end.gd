extends Area2D

signal win

@export var kale : Texture2D
@export var kale_visible = true

func _ready():
	if kale_visible:
		$Node2D/Kale.texture = kale
	else:
		$Node2D/Kale.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("win")
