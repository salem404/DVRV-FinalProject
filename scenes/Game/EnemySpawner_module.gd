extends Node2D

@export var enemies: Array[PackedScene] = []

@onready var Game: Node2D

################################################################################
#####                             Functions                                #####
################################################################################

func spawnEnemy(name: String):
	var selected = PackedScene
	for enemy in enemies:
		if enemy.get_file().get_basename() == name:
			selected = enemy
			break;
	if selected:
		var instance = selected.instantiate()
		add_child(instance)
	

################################################################################
#####                              Utility                                 #####
################################################################################
