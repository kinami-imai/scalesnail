extends Node2D


signal win
@export var player : Node
@export var textUre : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	player.integrate_forces_hooks.push_back(func(state):
		var tf = state.get_transform()
		tf.origin = $start.position
		state.set_transform(tf)
	)


func _on_end_win():
	emit_signal("win")
