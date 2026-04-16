extends Node2D

@export var enemies: Array[PackedScene] = []

@onready var Game: Node2D = get_parent()

func _ready():
	while true:
		await get_tree().create_timer(5.0).timeout
		spawnEnemy("Grimp", true)

################################################################################
#####                             Functions                                #####
################################################################################

func spawnEnemy(name: String, right: bool = true):
	var selected: PackedScene
	for enemy in enemies:
		if enemy.resource_path.get_file().get_basename() == name:
			selected = enemy
			break;
	if selected:
		var instance = selected.instantiate()
		instance.position = Game.gameCamera.position + (Vector2(1000,0) if right else Vector2(-1000,0))
		instance.MovingArea = Game.mapBoundry
		instance.Camera = Game.gameCamera
		add_child(instance)
		print("spawned")
	

################################################################################
#####                              Utility                                 #####
################################################################################
