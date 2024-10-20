extends CharacterBody2D
class_name Player

@onready var FlipX : Node2D = $FlipX
@onready var Anim : AnimationPlayer = $AnimationPlayer

@export var is_player1 : bool = true
@export var is_facing_right : bool = true

@export var SPEED : float= 300
@export var SPEED_DECAY : float = SPEED/5
@export var LADDER_SPEED : float  = 200
@export var JUMP : float = 500
@export var GRAVITY : float = 1400

var is_recent_x_left : bool = false
var is_recent_y_up : bool = false

var is_touching_ladder : bool = false
var ladder_x : float = 0
var is_climbing_ladder : bool = false

#####################
##### PROCESSES #####

func _ready():
	add_to_group("player")
	flipX(is_facing_right)

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	handle_x_movement()
	handle_ladder()
	move_and_slide()

############################
##### MOVEMENT METHODS #####

func apply_gravity(delta:float) :
	if !is_on_floor() && !is_climbing_ladder :
		velocity += Vector2(0,GRAVITY) * delta

func handle_jump() :
	if Input.is_action_just_pressed(IN("up")) && is_on_floor() :
		jump()

func jump() :
	velocity.y = -JUMP

func handle_x_movement() :
	var direction = get_x_input()
	if direction:
		velocity.x = direction * SPEED
		flipX(direction > 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_DECAY)

func handle_ladder() :
	if !is_touching_ladder :
		if is_climbing_ladder : jump() #jump off the top of the ladder (will happen at the bottom of ladders too but idrc)
		is_climbing_ladder = false
		return
	
	#order matters
	var x_in : float = get_x_input()
	var y_in : float = get_y_input()
	if Input.is_action_pressed(IN("ladderhold")) :
		is_climbing_ladder = true
		position.x = ladder_x
		velocity = Vector2.ZERO
		if y_in :
			is_climbing_ladder = true
			velocity.x = 0
			velocity.y = y_in * LADDER_SPEED
	elif Input.is_action_just_released(IN("ladderhold")) && y_in < 0 :
		jump()
		is_climbing_ladder = false
	elif is_climbing_ladder :
		if x_in || y_in :
			is_climbing_ladder = false
			if y_in < 0 :
				jump()

func flipX(right : bool) :
	if right :
		is_facing_right = true
		FlipX.scale.x = 1
	else : 
		is_facing_right = false
		FlipX.scale.x = -1
	
################
##### INPUT #####

func get_x_input() -> float :
	if Input.is_action_just_pressed(IN("left")) : is_recent_x_left = true
	if Input.is_action_just_pressed(IN("right")) : is_recent_x_left = false
	
	if is_recent_x_left : return -1 * Input.get_action_strength(IN("left"))
	else : return Input.get_action_strength(IN("right"))
	
func get_y_input() -> float :
	if Input.is_action_just_pressed(IN("up")) : is_recent_y_up = true
	if Input.is_action_just_pressed(IN("down")) : is_recent_y_up = false
	
	if is_recent_y_up : return -1 * Input.get_action_strength(IN("up"))
	else : return Input.get_action_strength(IN("down"))

func IN(s : String) :
	if is_player1 : return "p1" + s
	else : return "p2" + s
	
