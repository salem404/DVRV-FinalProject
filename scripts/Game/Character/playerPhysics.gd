extends CharacterBody2D

@export_category("Objects")
@export var MovingArea: Area2D
@export var Camera: Camera2D
@onready var PlayerModule: Node = $PlayerModule
@onready var CollisionBox: CollisionShape2D = $CollisionBox

func _ready():
	if MovingArea: 
		PlayerModule.MovementModule.MovingArea = MovingArea
		PlayerModule.MovementModule.boundryPolygon = MovingArea.get_node("CollisionPolygon2D").polygon
	else:
		push_warning("MovingArea not found in ", name)

func _physics_process(delta):
	PlayerModule.MovementModule.movementProcess(delta)
