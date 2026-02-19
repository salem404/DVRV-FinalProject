extends Node

@onready var player: CharacterBody2D = get_parent()

@onready var MovementModule: Node = $MovementModule
@onready var InputModule: Node = $InputModule
@onready var StatusModule: Node = $StatusModule
@onready var StatsModule: Node = $StatsModule

func _ready():
	MovementModule.character = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var canMove: bool = StatusModule.canMove()
	
	if canMove:
		MovementModule.moveTo(InputModule.movement, StatsModule.Speed)
		
		if InputModule.jumpKey:
			MovementModule.jump(StatsModule.Jpower)
	else:
		player.isMoving = false
