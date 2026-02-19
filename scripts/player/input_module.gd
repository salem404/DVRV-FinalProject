extends Node


var movement: Vector2 = Vector2(0,0)
var jumpKey: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement.y = Input.get_axis("MoveUp","MoveDown")
	movement.x = Input.get_axis("MoveLeft","MoveRight")
	
	jumpKey = Input.is_action_pressed("Jump")
	
