extends Node2D


@export var levels : Array[PackedScene]
@export var end_scene : PackedScene
@onready var globals = get_node("/root/Globals")


var jump = false
var scaled = false

@onready var next_level = globals.lvl_to_go_to

# Called when the node enters the scene tree for the first time.
func _ready():
	load_next_level()

func load_next_level():
	load_level_idx(next_level)
	next_level += 1

func load_level_idx(idx : int):
	if levels.size() <= idx:
		get_tree().change_scene_to_packed(end_scene)
		return
	load_level(levels[idx])

func load_level(level : PackedScene):
	jump = false
	scaled = false
	for child in get_children():
		child.queue_free()
		await child.tree_exited
	var new_level = level.instantiate()
	new_level.player = get_node("../Player")
	add_child(new_level)
	new_level.connect("win", get_parent().play_win_animation)

func reset():
	load_level_idx(next_level-1)
	get_parent().reset_scale()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_N and event.is_pressed():
		load_next_level()
	if event is InputEventKey and event.keycode == KEY_R and event.is_pressed():
		reset()
