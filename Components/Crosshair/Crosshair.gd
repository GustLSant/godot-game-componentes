class_name Crosshair
extends Control

@export var color:Color = Color.WHITE

# Render
const DOT_RADIUS:float = 1.0
const LINE_WIDTH:float = 1.0
const LINE_LENGTH:float = 12.0

# Behaviour
const TRANS_TIME:float = 10.0
const MIN_DISTANCE_TO_CENTER:float = 5.0
const AIM_DISTANCE_VARIANCE:float = 10.0  # distância que varia conforme o jogador está mirando ou não
const MOVE_DISTANCE_VARIANCE:float = 15.0 # distância que varia conforme o jogador está se movendo ou não
var currentDistanceToCenter:float = 10.0

# Accuracy by weapon spread
const WEAPON_SPREAD_SCALE:float = 5.0 # cada grau de spread da arma vai resultar em 5 pixels de abertura do crosshair
var weaponSpreadFactor:float = 0.0

@onready var centerPos:Vector2 = get_viewport_rect().size / 2


func _ready()->void:
	self.connect('resized', _on_screen_resized)
	_on_screen_resized()
	pass


func _process(delta:float)->void:
	var player:TpsFpsPlayer = $"../../ThirdPersonShooterPlayer"
	
	var alphaFpsCamera:float = (
		1.0 * int(not player.isAiming) - 
		0.5 * int(player.isSprinting)
	)
	
	var alphaTpsCamera:float = (
		1.0 * int(player.isAiming)
	)
	
	color.a = lerp(
		color.a,
		alphaFpsCamera * int(player.currentCameraMode == player.CAMERA_MODES.FIRST_PERSON) +
		alphaTpsCamera * int(player.currentCameraMode == player.CAMERA_MODES.THIRD_PERSON),
		TRANS_TIME*delta
	)
	
	currentDistanceToCenter = lerp(
		currentDistanceToCenter,
		(
			MIN_DISTANCE_TO_CENTER + 
			AIM_DISTANCE_VARIANCE * int(not player.isAiming) + 
			MOVE_DISTANCE_VARIANCE * int(player.isMoving) +
			MOVE_DISTANCE_VARIANCE * int(player.isSprinting) +
			weaponSpreadFactor * WEAPON_SPREAD_SCALE
		),
		TRANS_TIME*delta
	)
	
	queue_redraw()
	pass


func _draw()->void:
	draw_circle(
		centerPos,
		DOT_RADIUS,
		color
	)
	
	# linha de cima
	draw_line(
		centerPos + Vector2.UP * currentDistanceToCenter,
		centerPos + Vector2.UP * (currentDistanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha de baixo
	draw_line(
		centerPos + Vector2.DOWN * currentDistanceToCenter,
		centerPos + Vector2.DOWN * (currentDistanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha da direita
	draw_line(
		centerPos + Vector2.RIGHT * currentDistanceToCenter,
		centerPos + Vector2.RIGHT * (currentDistanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha da esquerda
	draw_line(
		centerPos + Vector2.LEFT * currentDistanceToCenter,
		centerPos + Vector2.LEFT * (currentDistanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	pass


func _on_screen_resized()->void:
	centerPos = get_viewport_rect().size / 2
	pass
