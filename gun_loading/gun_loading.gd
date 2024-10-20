extends Node2D
class_name Gunloading

@onready var DoneButton = get_node("UI/DoneButton")
@onready var Anim = $AnimationPlayer

@export var num_cartridges = 0
@export var chambers : Array[Chamber]

var cylinder : Array[bool]
var chambers_full : int = 0

var mouse_down : bool = false
var mouse_was_down : bool = false
var mouse_pressed : bool = false
var mouse_released : bool = false

func _ready():
	DoneButton.connect("pressed", on_done_pressed)

func _process(delta):
	update_button_state()
	update_mouse_info()

func update_mouse_info() :
	mouse_was_down = mouse_down
	mouse_down = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	mouse_pressed = false
	mouse_released = false
	if mouse_down && !mouse_was_down : mouse_pressed = true
	if !mouse_down && mouse_was_down : mouse_released = true

func update_button_state() :
	#only allow the done button to be pressed if all of the cartridges have been placed in a chamber
	if chambers_full == num_cartridges : DoneButton.disabled = false 
	else : DoneButton.disabled = true

func cartridge_dropped(c : Cartridge) :
	for i in chambers.size() :
		if !chambers[i].is_filled && chambers[i].has_point(c.global_position) : #catridge was dropped on an empty chamber
			add_cart_to_cham(c, chambers[i])
			return
	c.return_to_start_pos()

func add_cart_to_cham(ca : Cartridge, ch : Chamber) :
	Anim.play("load")
	ca.global_position = ch.global_position
	ca.is_in_chamber = true
	ch.cartridge = ca
	ch.is_filled = true
	chambers_full += 1

func empty_chamber(ch : Chamber) :
	Anim.play("unload")
	if !ch.cartridge : return
	ch.cartridge.return_to_start_pos()
	ch.cartridge.is_in_chamber = false
	ch.cartridge = null
	ch.is_filled = false
	chambers_full -= 1

func on_done_pressed() :
	#aimation calls next_scene
	Anim.play("confirm")
	
func next_scene() :
	#collect chamber info for cylinder array
	for i in chambers.size() : cylinder.append(chambers[i].is_filled)
	
	#go to the next scene (depends on which player is loading the gun)
	if GameContainer.GAME_CONTAINER.is_player1_loading :
		GameContainer.GAME_CONTAINER.cylinder1 = cylinder.duplicate()
		GameContainer.GAME_CONTAINER.is_player1_loading = false
		GameContainer.GAME_CONTAINER.switch_to_scene(GameContainer.GAME_CONTAINER.Scene.P2_READY)
	else :
		GameContainer.GAME_CONTAINER.is_player1_loading = true
		GameContainer.GAME_CONTAINER.cylinder2 = cylinder.duplicate()
		GameContainer.GAME_CONTAINER.switch_to_scene(GameContainer.GAME_CONTAINER.Scene.CUT_SCENE)
	
	
