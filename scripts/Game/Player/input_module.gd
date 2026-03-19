extends Node

@export var active: bool = true
var movement: Vector2 = Vector2(0,0)
var jumpKey: bool
var lightAttack: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		movement.y = Input.get_axis("MoveUp","MoveDown")
		movement.x = Input.get_axis("MoveLeft","MoveRight")
		
		jumpKey = Input.is_action_just_pressed("Jump")
		lightAttack = Input.is_action_just_pressed("LightAttack")
	
