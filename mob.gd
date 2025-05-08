extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	#It didn't say to add this when reading the tutorial, but this is how I was able to get the animations to finally play lol
	$AnimatedSprite2D.play()
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
