extends Node

@export var pipe_scene : PackedScene

var game_running: bool = false
var game_over : bool= false
var score
var scroll
const SCROLL_SPEED: int = 3
var screen_size: Vector2i
var ground_height: int
var pipes : Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 60



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	var ground_rect = $Ground.get_node("TileMap").get_used_rect()
	ground_height = ground_rect.size.x
	new_game()
	

func new_game():
	game_running = false
	game_over= false
	score = 0
	scroll = 0
	$ScoreLabel.text = 'SCORE: ' + str(score)
	get_tree().call_group('pipes','queue_free')
	$GameOver.hide()
	pipes.clear()
	#get first pipe
	generate_pipes()
	$Bird.reset()
	

func _input(event):
	if !game_over:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if !game_running: 
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()


func start_game():
	game_over = false
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()
	
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(bird_scored)
	add_child(pipe)
	pipes.append(pipe)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()
		
func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running= false
	game_over = true
	

func bird_hit():
	$Bird.falling = true
	stop_game()
	
func bird_scored():
	score += 1
	$ScoreLabel.text = 'SCORE: ' + str(score)


func _on_ground_hit():
	$Bird.falling = false
	stop_game()


func _on_game_over_restart():
	new_game()
