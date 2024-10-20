extends Node2D

@onready var bullet : PackedScene = preload("res://game/bullet/bullet.tscn")
@onready var player : Player = get_parent().get_parent()

@export var bullet_speed : float = 300

var cylinder : Array[bool] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] #like the cylinder of a revolver (all the 1s are for debug)
var cylinder_index : int = -1
var gun_direction : Vector2 = Vector2(1,0)
var is_reloaded : bool = true

func _ready():
	if GameContainer.GAME_CONTAINER : 
		if player.is_player1 : cylinder = GameContainer.GAME_CONTAINER.cylinder2 #note that the 1->2 2->1 is not a mistake, the players switch guns (depicted in the cut scene) so that they don't know which shots are blanks
		else : cylinder = GameContainer.GAME_CONTAINER.cylinder1

func _process(delta):
	## shooting ##
	if get_shoot_input() : shoot()
	
	## gun direction ##
	if player.is_facing_right : gun_direction = Vector2(1,0)
	else : gun_direction = Vector2(-1,0)
	
func shoot() -> bool :
	if !is_reloaded : return false
	# attempts to shoot a bullet, returns whether a bullet was shot
	cylinder_index += 1
	# determine whether there is another bullet/if the bullet is a blank
	if cylinder_index >= cylinder.size() : return false #out of bullets
	if !cylinder[cylinder_index] : return false #bullet is a blank 
	
	#shoot a bullet
	var b = bullet.instantiate()
	add_child(b)
	b.type = Bullet.Type.REGULAR
	b.position = global_position
	b.velocity = bullet_speed * gun_direction
	
	player.get_node("ShootNoise").play()
	player.Anim.play("reload") #will eventually call reload
	is_reloaded = false
	
	return true

func reload() :
	is_reloaded = true

func get_shoot_input() -> bool :
	return Input.is_action_just_pressed(player.IN("shoot"))
