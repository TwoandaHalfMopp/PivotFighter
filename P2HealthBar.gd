extends TextureProgressBar

func _ready():
	max_value = $"../../Character".MaxHealth
	min_value = 0
	value = $"../../Character".CurrentHealth
	$P2HealthLabel.text = str(value)

func _process(delta):
	value = $"../../Character".CurrentHealth
	$P2HealthLabel.text = str(value)
