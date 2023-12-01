extends Node2D

@onready var initial_scale = Vector2(1152,648)
@onready var tada = get_node("../endscreen/tada/scale")
@onready var endcard = get_node("../endscreen/endcard")
@onready var win_badge = get_node("../endscreen/win")
@onready var jump_badge = get_node("../endscreen/jump")
@onready var scale_badge = get_node("../endscreen/scale")
@onready var globals = get_node("/root/Globals")

var on_end_screen = false

const grey = Color(0.32,0.32,0.32,0.32)
const white = Color(1,1,1,1)

var window
var viewport

var resize_tl
var resize_br

# Called when the node enters the scene tree for the first time.
func _ready():
	if false:
		viewport = get_node("..")
		window = viewport.get_node("../..")
		window.size = get_window().size/2
		window.set_anchors_preset(8)
	else:
		viewport = get_viewport()
		window = get_window()
		viewport.connect("size_changed", _on_viewport_resize)
	get_node("../music").volume_db = (globals.music_volume/10*3)-30
	get_node("../sound").volume_db = (globals.sound_volume/10*3)-30
	get_node("../endscreen/ding").volume_db = (globals.music_volume/10*3)-42
	get_node("../endscreen/full").volume_db = (globals.music_volume/10*3)-35
	get_node("../endscreen/partial").volume_db = (globals.music_volume/10*3)-35

func _process(delta):
	if resize_br:
		window.size = get_global_mouse_position() - window.position

func _on_viewport_resize():
	if on_end_screen:
		$reset_timer.start(0.5)
		return
	$Borders.scale = Vector2(float(viewport.size.x)/float(initial_scale.x), float(viewport.size.y)/float(initial_scale.y))
	$level_loader.scale = $Borders.scale
	$level_loader.scaled = true

func reset_scale():
	window.size = initial_scale

func show_badge(badge):
	badge.modulate = grey
	badge.visible = true

func play_win_animation():
	if on_end_screen:
		return
	reset_scale()
	on_end_screen = true
	if not get_node("../music").playing:
		get_node("../music").play()
	print("You win!")
	var jump_badge_earned = !$level_loader.jump
	var scale_badge_earned = !$level_loader.scaled
	globals.achievements[$level_loader.next_level-1]={
		"completed": true,
		"jump": globals.achievements[$level_loader.next_level-1].jump || jump_badge_earned,
		"scale": globals.achievements[$level_loader.next_level-1].scale || scale_badge_earned
	}
	get_node("../endscreen/bite").visible = false
	tada.get_node("../content/Icon").texture = $level_loader/level/end.kale
	tada.play("scale")
	$Player.freeze()
	$Player/sprite/sad.visible = false
	await tada.animation_finished
	get_node("../endscreen/texts/variable").texture = $level_loader/level.textUre
	get_node("../endscreen/fallin").play("fallin")
	if $level_loader.next_level == 1:
		get_node("../endscreen/partial").play()
	else:
		get_node("../endscreen/full").play()
	await get_node("../endscreen/fallin").animation_finished
	get_node("../endscreen/next_level_button").visible = true
	show_badge(win_badge)
	show_badge(jump_badge)
	show_badge(scale_badge)
	get_node("../endscreen/movein").play("RESET")
	await get_tree().create_timer(0.5).timeout
	win_badge.modulate = white
	get_node("../endscreen/ding").play()
	if jump_badge_earned:
		await get_tree().create_timer(0.5).timeout
		get_node("../endscreen/ding").play()
		jump_badge.modulate = white
	if scale_badge_earned:
		await get_tree().create_timer(0.5).timeout
		get_node("../endscreen/ding").play()
		scale_badge.modulate = white
	await get_tree().create_timer(0.5).timeout

func next_level():
	get_node("../endscreen/fallin").play("unfall")
	get_node("../endscreen/next_level_button").visible = false
	endcard.visible = true
	get_node("../endscreen/movein").play("movein")
	await get_node("../endscreen/movein").animation_finished
	(endcard as AnimatedSprite2D).play("default")
	await get_tree().create_timer(1).timeout
	get_node("../endscreen/bite").visible = true
	await get_tree().create_timer(1.5).timeout
	$level_loader.load_next_level()
	get_node("../endscreen/movein").play("eyes")
	await endcard.animation_finished
	tada.play("unscale")
	win_badge.visible = false
	jump_badge.visible = false
	scale_badge.visible = false
	get_node("../endscreen/bite").visible = false
	await get_tree().create_timer(0.1).timeout
	$Player/vflipper.play("flip")
	$Player/vflipper.stop()
	$Player/hflipper.play("hflip")
	$Player/hflipper.stop()
	$Camera2D.position = $Player.position+Vector2(76,0)
	$Camera2D.zoom = Vector2(8.2,8.2)
	$Camera2D.move=false
	$Camera2D.enabled = true
	$Player/sprite/surprised.visible = true
	await tada.animation_finished
	endcard.visible = false
	$Camera2D.move=true
	await get_tree().create_timer(5).timeout
	$Player/sprite/surprised.visible = false
	$Player.unfreeze()
	on_end_screen = false


func _on_next_level_pressed():
	next_level()


func _on_reset_timer_timeout():
	reset_scale()


func _on_button_button_down():
	print("br")
	resize_br = true


func _on_button_2_button_down():
	print("tl")
	resize_tl = true


func _on_button_button_up():
	resize_br = false


func _on_button_2_button_up():
	resize_tl = false
