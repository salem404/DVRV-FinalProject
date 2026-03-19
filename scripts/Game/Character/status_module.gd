extends Node

var onAir: bool = false
var isStunned: bool = false
var isDebounced: bool = false

@onready var StunTimer: Timer = $StunTimer
@onready var DebounceTimer: Timer = $DebounceTimer

func canMove() -> bool:
	return not (isStunned or isDebounced)

func applyStun(time: float):
	if time > StunTimer.time_left:
		StunTimer.start(time)
		isStunned = true
		await StunTimer.timeout
		isStunned = false

func applyDebounce(time: float):
	if time > DebounceTimer.time_left:
		DebounceTimer.start(time)
		isDebounced = true
		await DebounceTimer.timeout
		isDebounced = false
