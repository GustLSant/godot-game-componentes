extends Control

@export var color:Color = Color.WHITE

const DOT_RADIUS:float = 1.0
const LINE_WIDTH:float = 1.0
const LINE_LENGTH:float = 12.0

var distanceToCenter:float = 10.0
var centerPos:Vector2 = get_viewport_rect().size / 2


func _ready()->void:
	self.connect('resized', _on_screen_resized)
	_on_screen_resized()
	pass


func _process(delta:float)->void:
	var player := $"../../ThirdPersonShooterPlayer"
	color.a = lerp(color.a, 0.25 + float(int(player.isAiming)), 10*delta)
	distanceToCenter = lerp(distanceToCenter, 5.0 + 20.0 * float(int(not player.isAiming)), 10*delta)
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
		centerPos + Vector2.UP * distanceToCenter,
		centerPos + Vector2.UP * (distanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha de baixo
	draw_line(
		centerPos + Vector2.DOWN * distanceToCenter,
		centerPos + Vector2.DOWN * (distanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha da direita
	draw_line(
		centerPos + Vector2.RIGHT * distanceToCenter,
		centerPos + Vector2.RIGHT * (distanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	
	# linha da esquerda
	draw_line(
		centerPos + Vector2.LEFT * distanceToCenter,
		centerPos + Vector2.LEFT * (distanceToCenter + LINE_LENGTH),
		color, LINE_WIDTH
	)
	pass


func _on_screen_resized()->void:
	centerPos = get_viewport_rect().size / 2
	pass
