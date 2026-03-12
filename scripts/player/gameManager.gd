extends Node2D

@export var PackedPlayerGUI: PackedScene
@export var PackedPlayers: Array[PackedScene] = []

@onready var gameGUI: Control = $Ui
@onready var PlayersGUI: HBoxContainer = gameGUI.get_node("PlayersGUI")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_players()
		

func spawn_players():
	for player in PackedPlayers:
		var instance = player.instantiate()
		instance.MovingArea = $Map/Boundry
		$Players.add_child(instance)
		spawnPlayerGUI(instance)

func spawnPlayerGUI(player: CharacterBody2D):
	var instance = PackedPlayerGUI.instantiate()
	instance.playerStats = player.get_node("PlayerModule/StatsModule")
	PlayersGUI.add_child(instance)
