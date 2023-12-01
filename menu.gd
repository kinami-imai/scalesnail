extends Control

@export var main_scene : PackedScene

@onready var globals = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	$tada/scale.play("scale")
	$menus/options/fullscreen.button_pressed = globals.skip_intro
	$menus/options/music/HSlider.value = globals.music_volume
	$menus/options/sound/HSlider.value = globals.sound_volume
	var prev_level_complete = true
	for i in range(globals.achievements.size()-1):
		var current = $menus/levelselect.get_child(i)
		if not prev_level_complete:
			current.disabled = true
		current.pressed.connect(func ():
			globals.lvl_to_go_to = i
			get_tree().change_scene_to_packed(main_scene)
		)
		prev_level_complete = globals.achievements[i].completed
		current.get_node("Control/win").visible = globals.achievements[i].completed
		current.get_node("Control/jump").visible = globals.achievements[i].jump
		current.get_node("Control/scale").visible = globals.achievements[i].scale


func switch_to_menu(selected):
	for child in $menus.get_children():
		child.visible = false
	selected.visible = true

func _on_back_pressed():
	switch_to_menu($menus/main)


func _on_level_select_pressed():
	switch_to_menu($menus/levelselect)


func _on_options_pressed():
	switch_to_menu($menus/options)


func _on_credits_pressed():
	switch_to_menu($menus/credits)


func _on_start_pressed():
	globals.lvl_to_go_to = 0
	get_tree().change_scene_to_packed(main_scene)


func _on_h_slider_value_changed(value):
	globals.music_volume = value
	$AudioStreamPlayer.volume_db = (globals.music_volume/10*3)-30


func _on_fullscreen_toggled(button_pressed):
	globals.skip_intro = button_pressed
#	if button_pressed:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#	else:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_music_slider_value_changed(value):
	globals.sound_volume = value


func _on_quit_pressed():
	get_tree().quit()
