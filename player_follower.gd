extends Node2D

@export var FollowPlayer:bool = true

@onready var players: Array[CharacterBody2D] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FollowPlayer:
		for player in players:
			if player.position.x >= position.x:
				position.x = player.position.x
