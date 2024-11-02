extends Sprite2D


@onready var Anim : AnimationPlayer = $AnimationPlayer

func _ready():
	Anim.play("scene")

func next_frame() :
	if frame == 9 :
		GameContainer.GAME_CONTAINER.switch_to_scene(GameContainer.GAME_CONTAINER.Scene.DUEL_STAGE)
	else :
		frame += 1
	
