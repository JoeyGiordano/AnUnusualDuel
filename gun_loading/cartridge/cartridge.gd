extends Node2D
class_name Cartridge

@onready var GunLoading : Gunloading = get_parent().get_parent()
@onready var RefRect : ReferenceRect = $ReferenceRect
@onready var Sprite : Sprite2D = $Sprite2D
@onready var start_position : Vector2 = global_position

var is_being_dragged : bool = false
var is_in_chamber : bool = false

func _process(delta):
	handle_dragging()
	
	if is_being_dragged : Sprite.rotation = 0.15*sin(7.0*Time.get_ticks_msec()/1000.0)
	else : Sprite.rotation = 0
	
	if is_in_chamber : Sprite.hide()
	else : Sprite.show()

func handle_dragging() :
	var rect : Rect2 = Rect2(RefRect.global_position, RefRect.size)
	var mouse_pos : Vector2 = get_global_mouse_position()
	
	# while dragging
	if is_being_dragged : 
		global_position = mouse_pos
	
	#start dragging
	if GunLoading.mouse_pressed && !is_in_chamber && rect.has_point(mouse_pos) :
		is_being_dragged = true
		z_index = 1
	
	#stop dragging
	if is_being_dragged && GunLoading.mouse_released :
		is_being_dragged = false
		GunLoading.cartridge_dropped(self)
		z_index = 0

func return_to_start_pos() :
	global_position = start_position
