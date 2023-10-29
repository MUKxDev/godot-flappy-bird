extends Node

var game_running: bool = false
var game_over : bool= false
var score
var scroll
const SCROLL_SPEED: int = 3
var screen_size: Vector2i
var ground_height: int
var pipes : Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()
	

func new_game():
	game_running = false
	game_over= false
	score = 0
	scroll = 0
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


func start_game():
	game_over = false
	game_running = true
	$Bird.flying = true
	$Bird.flap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
