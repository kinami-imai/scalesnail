extends Camera2D

@onready var initial_pos = position
@onready var initial_zoom = zoom

var move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not move:
		return
	if position == initial_pos and zoom == initial_zoom:
		enabled = false
	if (position - initial_pos).length() < 10:
		position = initial_pos
	elif (position - initial_pos).length() < 100:
		position += (initial_pos-position).normalized()*delta*200
	else:
		position += (initial_pos-position).normalized()*delta*2000/zoom.length()/zoom.length()
	if (zoom-initial_zoom).length() < 0.02:
		zoom = initial_zoom
	else:
		zoom += (initial_zoom-zoom).normalized()*delta*2
