extends Node2D
@onready var globals = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().player.get_node("sprite/sad").visible = true
	if not globals.skip_intro:
		get_parent().player.freeze()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dialog":
		print("unfreeze")
		get_parent().player.unfreeze()
		$AnimationPlayer.play("instructions")
