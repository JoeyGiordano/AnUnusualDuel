extends Area2D
class_name Bullet

var type : Type = Type.REGULAR
var velocity : Vector2 = Vector2(10,0)

enum Type {
	REGULAR
}

func _ready():
	add_to_group("bullet")
	top_level = true #makes the bullets transform relative to the world transform (instead of its parent's transform)
	connect("body_entered", on_body_entered)

func _process(delta):
	pass
	
func _physics_process(delta):
	position += velocity * delta  #move the bullet
	
func on_body_entered(body : Node2D) :
	if body.is_in_group("player_hitbox") : return
	if body.is_in_group("player") : return
	destroy()
	
func destroy() :
	queue_free()
