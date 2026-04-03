class_name PlayerMovementMapper
extends Node

@export var manager: PlayerManager
@export var player: CharacterBody3D


func _ready() -> void:
	manager.crouchModule.connect("CrouchChanged", handleCrouchChanged)
	manager.sprintModule.connect("SprintChanged", handleSprintChanged)
	pass


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO
	
	$"../../StandingCollider".disabled = manager.crouchModule.isCrouched or manager.diveModule.isDiving
	$"../../CrouchCollider".disabled = not manager.crouchModule.isCrouched
	$"../../DiveCollider".disabled = not manager.diveModule.isDiving
	
	$"../../DiveCollider".shape.size = manager.diveModule.currentColliderSize
	$"../../DiveCollider".position.y = manager.diveModule.currentColliderHeight
	
	player.velocity += manager.fpsWalkModule.walkVec
	player.velocity.y += manager.gravityModule.motion
	
	player.velocity *= manager.sprintModule.speedMultiplier
	player.velocity *= manager.crouchModule.speedMultiplier
	player.velocity.y += manager.jumpModule.motion
	player.velocity += manager.diveModule.motion
	
	player.move_and_slide()
	
	# PROBLEMA:
		# TEM QUE TER A VELOCIDADE DO SPRINT NA ADIÇÃO DO DIVE, MAS NAO PODE TER MUDANÇA DE INPUT DE SPRINT DURANTE O DIVE
	# raiz do problema:
		# o handler nao tem acesso a quando o SprintModule executará
	# impedimento que causa o problema: 
		# a ideia era ter varios handlers, um para cada sistema, porem alguns controllers afetarão
		# mais de um sistema (ex: crouch que mexe na velocidade de movimento e altura da camera) e nao é
		# recomendado executar um controller mais de uma vez por frame (mesmo? se eh a msm instancia..),
		# precisaria separar local de injeção de dependencia + execução com o local da utilizacao dos dados
	
	# possivel solucao 1:
		# adicionar uma variavel interna aos controllers para barrar sua execucao
		# e essa variavel seria controlada pelo handler
	
	# possivel solucao 2:a pelo manager, dai a funcao run seria executada pelos handlers
		# e como seria uma 're-execução' da mesma instancia, nao teria problema de lógica (tlvz uma pequena perda de performance)
		
		# CENARIO QUE PODE DAR ERADO:
			# so pode alterar o isSprinting enquando nao estiver em dive
			# no MovementHandler o s
		# mudar os controllers para ter uma funcao setup onde eles guardariam todas as suas dependencias
		# essa funcao seria executadprintHandler pode facilmente ser travado
			# mas quando for re-executar ele para aplicar os efeitos na camera, o isSprinting pode ser alterado (e nao deveria)
	
	# possivel solucao 3:
		# ter um script de resolucao de conflitos e orquestração de quem q vai executar e quando (poderia ser o manager?)
		# e ter um script para usar de fato os valores resolvidos pelos controllers
	pass


func handleCrouchChanged(_newState: bool) -> void:
	if (_newState): manager.sprintModule.changeSprinting(false)
	pass


func handleSprintChanged(_newState: bool) -> void:
	if (_newState): manager.crouchModule.changeCrouch(false)
	pass
