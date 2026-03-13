extends CharacterBody2D

@export_category("Objects")
@export var MovingArea: Area2D

var boundryPolygon

var isMoving: bool = false
var outsideArea: bool = false

func _ready():
	if MovingArea: 
		boundryPolygon = MovingArea.get_node("CollisionPolygon2D").polygon
	else:
		push_warning("MovingArea not found in ", name)

func _physics_process(delta):
	var oldPos = position

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	if not isMoving:
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	
	if MovingArea and not Geometry2D.is_point_in_polygon(position, boundryPolygon):
		#position = oldPos
		outsideArea = true
		snapInsidePolygon()
	else:
		outsideArea = false
		

func moveTo(movement: Vector2):
	velocity.x = movement.x
	velocity.y = movement.y

func moveXTo(movementX: float):
	velocity.x = movementX
	
func moveYTo(movementY: float):
	velocity.y = movementY
	
func applyForce(force: Vector2):
	velocity.x += force.x
	velocity.y += force.y

func snapInsidePolygon():
	# If inside, distance is zero

	var min_distance := INF
	var min_distPos = null

	for i in boundryPolygon.size():
		var a = boundryPolygon[i]
		var b = boundryPolygon[(i + 1) % boundryPolygon.size()]

		var closest = Geometry2D.get_closest_point_to_segment(position, a, b)
		var dist = position.distance_to(closest)

		if dist < min_distance:
			min_distance = dist
			min_distPos = closest
			
	if min_distPos: 
		position = min_distPos
