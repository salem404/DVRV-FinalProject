extends Node2D

@export var events: Array[Area2D] = []

@onready var PlayerFollower: Node2D = get_parent().get_node("PlayerFollower")

# Called when the node enters the scene tree for the first time.
func _ready():
	events[0].Activated.connect(wave1)
	

func wave1():
	PlayerFollower.FollowPlayer = false
	pass
