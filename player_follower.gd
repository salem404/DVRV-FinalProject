extends Node2D

@export var FollowPlayer:bool = true

@export var FollowingPlayer: Array[Node2D] = []
@export var FollowingPlayerUI: Array[Control] = []
@onready var players: Array[CharacterBody2D] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var updatedX = 0
	if FollowPlayer:
		for player in players:
			if player and player.position.x >= position.x:
				updatedX = player.position.x - position.x
	if updatedX != 0:
		position.x += updatedX
		updatePos(updatedX, FollowingPlayer)
		updatePos(updatedX, FollowingPlayerUI)

func updatePos(updatedX, Followers):
	for follower in Followers:
		if follower:
			follower.position.x += updatedX
	
