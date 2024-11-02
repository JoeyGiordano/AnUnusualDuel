extends Area2D

@onready var player : Player = get_parent()

func _ready():
	add_to_group("player_hitbox")
	connect("area_entered", on_area_entered) #connect on_area_entered() to the area2d signal area_entered
	connect("area_exited", on_area_exited) #connect on_area_exited() to the area2d signal area_exited

func on_area_entered(area : Area2D) :
	if area.is_in_group("bullet") :
		area.destroy()
		player.get_node("FlipX/Sprite2D").frame += 1
		player.alive = false
		player.velocity.x = -200 * sign(area.position.x - player.position.x)
		await get_tree().create_timer(1).timeout
		#TODO ^^REPLACE WITH ANIMATION
		GameContainer.GAME_CONTAINER.switch_to_scene(GameContainer.GAME_CONTAINER.Scene.VICTORY)
		return
	
	if area.is_in_group("ladder") :
		player.is_touching_ladder = true
		player.ladder_x = area.get_child(0).global_position.x
	
func on_area_exited(area : Area2D) : 
	if area.is_in_group("ladder") :
		player.is_touching_ladder = false
	
