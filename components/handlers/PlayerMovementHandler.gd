class_name PlayerMovementHandler
extends Node

@export var context: PlayerContext
@export var player: CharacterBody3D
@export var pivotCrouch: Marker3D


func _ready() -> void:
	context.crouchController.connect("CrouchChanged", handleCrouchChanged)
	context.sprintController.connect("SprintChanged", handleSprintChanged)
	
	
	pass


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO
	
	pivotCrouch.position.y = context.crouchController.state.heightOffset
	
	$"../../StandingCollider".disabled = context.crouchController.state.isCrouched or context.diveController.isDiving
	$"../../CrouchCollider".disabled = not context.crouchController.state.isCrouched
	$"../../DiveCollider".disabled = not context.diveController.isDiving
	#if (context.diveController.state.isDiving): print($"../../DiveCollider".shape.size)
	#if (context.diveController.state.isDiving): print($"../../DiveCollider".position.y); print('')
	
	$"../../DiveCollider".shape.size = context.diveController.currentColliderSize
	$"../../DiveCollider".position.y = context.diveController.currentColliderHeight
	
	player.velocity += context.fpsWalkController.state.walkVec
	player.velocity.y += context.gravityController.state.motion
	
	# PROBLEMA:
		# TEM QUE TER A VELOCIDADE DO SPRINT NA ADIÇÃO DO DIVE, MAS NAO PODE TER MUDANÇA DE INPUT DE SPRINT DURANTE O DIVE
	# raiz do problema:
		# o handler nao tem acesso a quando o SprintController executará
	# impedimento que causa o problema: 
		# a ideia era ter varios handlers, um para cada sistema, porem alguns controllers afetarão
		# mais de um sistema (ex: crouch que mexe na velocidade de movimento e altura da camera) e nao é
		# recomendado executar um controller mais de uma vez por frame (mesmo? se eh a msm instancia..),
		# precisaria separar local de injeção de dependencia + execução com o local da utilizacao dos dados
	
	# possivel solucao 1:
		# adicionar uma variavel interna aos controllers para barrar sua execucao
		# e essa variavel seria controlada pelo handler
	
	# possivel solucao 2:
		# mudar os controllers para ter uma funcao setup onde eles guardariam todas as suas dependencias
		# essa funcao seria executada pelo context, dai a funcao run seria executada pelos handlers
		# e como seria uma 're-execução' da mesma instancia, nao teria problema de lógica (tlvz uma pequena perda de performance)
		
		# CENARIO QUE PODE DAR ERADO:
			# so pode alterar o isSprinting enquando nao estiver em dive
			# no MovementHandler o sprintHandler pode facilmente ser travado
			# mas quando for re-executar ele para aplicar os efeitos na camera, o isSprinting pode ser alterado (e nao deveria)
	
	# possivel solucao 3:
		# ter um script de resolucao de conflitos e orquestração de quem q vai executar e quando (poderia ser o context?)
		# e ter um script para usar de fato os valores resolvidos pelos controllers
	
	if (not context.diveController.isDiving):
		player.velocity *= context.sprintController.state.speedMultiplier
		player.velocity *= context.crouchController.state.speedMultiplier
		player.velocity.y += context.jumpController.state.motion
	else:
		player.velocity += context.diveController.motion
	
	player.move_and_slide()
	pass


func handleCrouchChanged(_newState: bool) -> void:
	if (_newState): context.sprintController.actions.changeSprinting.call(false)
	pass


func handleSprintChanged(_newState: bool) -> void:
	if (_newState): context.crouchController.actions.changeCrouch.call(false)
	pass
