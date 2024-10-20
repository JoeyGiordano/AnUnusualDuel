extends Node2D
class_name Chamber

@onready var GunLoading : Gunloading = get_parent().get_parent()
@onready var RefRect : ReferenceRect = $ReferenceRect
@onready var Sprite : Sprite2D = $Sprite2D

@export var chamber_num = 1 #start at 1

var is_hovered_over : bool = false
var is_filled : bool = false
var cartridge : Cartridge

func _process(delta):
	update_state()
	
	if is_hovered_over :
		Sprite.frame_coords.x = 1
	else :
		Sprite.frame_coords.x = 0
	
	if is_filled :
		Sprite.frame_coords.y = 1
	else :
		Sprite.frame_coords.y = 0

func update_state() :
	var rect : Rect2 = Rect2(RefRect.global_position, RefRect.size)
	
	if rect.has_point(get_global_mouse_position()) : #if the mouse is hovering over this chamber
		is_hovered_over = true
		if GunLoading.mouse_pressed && is_filled : #if the mouse tries to pull a cartridge out of the chamber
			cartridge.is_being_dragged = true
			GunLoading.empty_chamber(self)
	else :
		is_hovered_over = false

func has_point(point : Vector2) -> bool :
	var rect : Rect2 = Rect2(RefRect.global_position, RefRect.size)
	return rect.has_point(point)
		
