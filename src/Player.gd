extends Area2D
signal hit

export var speed = 400 # A quina velocitat es mourà el jugador (píxels/seg).
var screen_size # Mida de la finestra de joc.

export var move_right = "move_right"
export var move_left = "move_left"
export var move_down = "move_down"
export var move_up = "move_up"

var isAlive = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # Vector de moviment del jugador.
	if Input.is_action_pressed(move_right):
		velocity.x += 1
	if Input.is_action_pressed(move_left):
		velocity.x -= 1
	if Input.is_action_pressed(move_down):
		velocity.y += 1
	if Input.is_action_pressed(move_up):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body):
	isAlive = false
	hide() # El jugador desapareix després de ser impactat.
	emit_signal("hit")
	# S'ha d'ajornar, ja que no podem canviar les propietats físiques en una crida de retorn de física.
	#$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	isAlive = true
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func isAlive():
	return isAlive
