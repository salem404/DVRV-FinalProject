extends CharacterBody2D

@export_category("Objects")
@export var MovingArea: Area2D

@onready var boundryPolygon = MovingArea.get_node("CollisionPolygon2D").polygon


var isMoving: bool = false
var onFloor: bool = true
var setGravity: bool = true
var outsideArea: bool = false

var floorPos: float

func _physics_process(delta):
	var oldPos = position
	# Add the gravity.
	if setGravity and not onFloor:
		velocity += get_gravity() * delta
		
		if floorPos < position.y and velocity.y >= 0 and not outsideArea:
			onFloor = true

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	if not isMoving and onFloor:
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	
	if MovingArea and not Geometry2D.is_point_in_polygon(position, boundryPolygon):
		#position = oldPos
		outsideArea = true
		snapInsidePolygon()
	else:
		outsideArea = false
		
	if onFloor:
		floorPos = position.y

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
		if onFloor:
			position = min_distPos
		else:
			if position.y > min_distPos.y:
				position = min_distPos
				onFloor = true
