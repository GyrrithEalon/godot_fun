extends ParallaxBackground

var scolling_speed = 100

func _process(delta):
	scroll_offset.x -= scolling_speed * delta
