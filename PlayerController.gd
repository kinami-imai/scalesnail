extends RigidBody2D

const max_speed = 400
@onready var globals = get_node("/root/Globals")
@export var integrate_forces_hooks : Array 

var frozen = false

var upright = true

var facing_right = true

func _ready():
	$jump_sound.volume_db = (globals.sound_volume/10*3)-30

func _integrate_forces(state):
	if abs(rotation_degrees) > 100 and abs(rotation_degrees) < 260 and upright:
		$vflipper.play("flip")
		upright = false
	if abs(rotation_degrees) > 270 or abs(rotation_degrees) < 80 and not upright:
		$vflipper.play("unflip")
		upright = true
	for hook in integrate_forces_hooks:
		hook.call(state)
	integrate_forces_hooks = []
	if frozen:
		linear_velocity = Vector2(0,0)
		angular_velocity = 0
		rotation = 0
		return
	var input_dir = Input.get_axis("left", "right")
	if input_dir != 0:
		if !$move_sound.playing:
			$move_sound.play()
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
	if facing_right and input_dir < 0:
		if upright:
			$hflipper.play("hflip")
		else:
			$hflipper.play("hunflip")
		facing_right = false
	if not facing_right and input_dir > 0:
		if upright:
			$hflipper.play("hunflip")
		else:
			$hflipper.play("hflip")
		facing_right = true
	if linear_velocity.length() < max_speed:
		apply_impulse(Vector2(input_dir*10,0))

func _input(event):
	if event.is_action_pressed("back"):
		get_tree().change_scene_to_file("res://menu.tscn")
	if frozen:
		return
	if event.is_action_pressed("jump") and not get_colliding_bodies().size() == 0:
		apply_impulse(Vector2(0,-400))
		get_node("../level_loader").jump = true
		$jump_sound.play()



func _on_area_2d_area_entered(area):
	if area.name == "water":
		$drowning_timer.start(0.5)


func _on_area_2d_area_exited(area):
	if area.name == "water":
		$drowning_timer.stop()


func _on_drowning_timer_timeout():
	print("ded")
	get_node("../level_loader").reset()

func freeze():
	$AnimationPlayer.stop()
	gravity_scale = 0
	frozen = true
	collision_mask = 0

func unfreeze():
	gravity_scale = 1
	frozen=false
	collision_mask = 1
