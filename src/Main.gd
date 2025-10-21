extends Node
export(PackedScene) var mob_scene
var score
var score2

var player1Alive
var player2Alive 

func _ready():
	randomize()

func game_over():
	if $Player.isAlive == false and $Player2.isAlive == false:
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		$Music.stop()
	
	$DeathSound.play()

func new_game():
	score = 0
	score2 = 0
	$Player.start($StartPosition.position)
	$Player2.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score, score2)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_ScoreTimer_timeout():
	if $Player.isAlive:
		score += 1
	if $Player2.isAlive:
		score2 += 1
	
	$HUD.update_score(score, score2)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instance()
	# Trieu una ubicació aleatòria a Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	# Estableix la direcció de la multitud perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2
	# Estableix la posició de la multitud a una ubicació aleatòria.
	mob.position = mob_spawn_location.position
	# Afegeix una mica d'aleatorietat a la direcció.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Tria la velocitat de la multitud.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)
