extends Node
class_name GameContainer

#easy way to access the GameContainer from other nodes
static var GAME_CONTAINER : GameContainer

#There should only ever be one active scene (menu or stage) and it will be the only child of the ActiveSceneHolder node
@onready var ActiveSceneHolder = $ActiveSceneHolder
#Other scenes should be overlay panels (UI, eg pause menu) can be put in the OverlayPanels node
@onready var OverlayPanels = $OverlayPanels
#The player nodes are instantiated in the Players node, they can be hidden and frozen when necessary
@onready var Players = $Players

#Scenes
@onready var main_menu : PackedScene = preload("res://static_scenes/main_menu.tscn")
@onready var credits : PackedScene = preload("res://static_scenes/credits.tscn")
@onready var instructions : PackedScene = preload("res://static_scenes/instructions.tscn")
@onready var gun_loading : PackedScene = preload("res://gun_loading/gun_loading.tscn")
@onready var cut_scene : PackedScene = preload("res://cut_scene/cut_scene.tscn")
@onready var duel_stage : PackedScene = preload("res://game/duel_stage.tscn")
@onready var victory : PackedScene = preload("res://static_scenes/victory.tscn")
@onready var p1_ready : PackedScene = preload("res://static_scenes/player1_ready.tscn")
@onready var p2_ready : PackedScene = preload("res://static_scenes/player2_ready.tscn")
enum Scene {	#IMPORTANT: Adding, removing, or reording enum values can change the value of enum exports
	MAIN_MENU,
	CREDITS,
	INSTRUCTIONS,
	GUN_LOADING,
	CUT_SCENE,
	DUEL_STAGE,
	VICTORY,
	P1_READY,
	P2_READY
}

var is_player1_loading : bool = true
var cylinder1 : Array[bool]
var cylinder2 : Array[bool]


#### METHODS ####

func _ready():
	GAME_CONTAINER = self  #prepare the GAME_CONTAINER singleton (not an autoload)
	pass

func _process(delta):
	#quit if Q pressed - DEBUG
	if Input.is_key_pressed(KEY_Q) :
		get_tree().quit()
	pass

func switch_to_scene(scene_enum : Scene) :
	switch_active_scene(getSceneFromEnum(scene_enum))
	if scene_enum == Scene.P1_READY : 
		$MusicAnim.play("loading")
	if scene_enum == Scene.CUT_SCENE :
		$MusicAnim.stop()
		$MusicAnim.play("cutscene")
	if scene_enum == Scene.DUEL_STAGE : 
		$MusicAnim.stop()
		$MusicAnim.play("gameplay")

func switch_active_scene(scene : PackedScene) :
	ActiveSceneHolder.get_child(0).queue_free()  #remove the old scene
	var s = scene.instantiate()                  #instantiate the new scene
	ActiveSceneHolder.add_child(s)               #add the new scene as a child of the ActiveSceneHolder

func getSceneFromEnum(scene_enum : Scene) -> PackedScene:
	#get the packed scene that corresponds to the enum
	match (scene_enum) :
		Scene.MAIN_MENU : return main_menu
		Scene.CREDITS : return credits
		Scene.INSTRUCTIONS : return instructions
		Scene.GUN_LOADING : return gun_loading
		Scene.CUT_SCENE : return cut_scene
		Scene.DUEL_STAGE : return duel_stage
		Scene.VICTORY : return victory
		Scene.P1_READY : return p1_ready
		Scene.P2_READY : return p2_ready
		_ : 
			print("Scene not recognized")
			return main_menu
