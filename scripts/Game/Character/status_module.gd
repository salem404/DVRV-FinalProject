extends Node

var onAir: bool = false
var isStunned: bool = false
var isDebounced: bool = false
var isMoving: bool = false
var lookDir: int = 1 
var isKnockbacked: bool = false
var knockbackDir: int = 1 

@onready var StunTimer: Timer = $StunTimer
@onready var DebounceTimer: Timer = $DebounceTimer

func _process(delta):
	if isKnockbacked and not onAir and not isStunned:
		isKnockbacked = false

func canMove() -> bool:
	return not (isStunned or isDebounced)

func applyStun(time: float):
	if time > StunTimer.time_left:
		StunTimer.start(time)
		isStunned = true
		await StunTimer.timeout
		while onAir:
			await get_tree().process_frame
		isStunned = false

func applyDebounce(time: float):
	if time > DebounceTimer.time_left:
		DebounceTimer.start(time)
		isDebounced = true
		await DebounceTimer.timeout
		isDebounced = false
