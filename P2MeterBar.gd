extends TextureProgressBar

func _ready():
	max_value = $"../../Character".MaxMeter
	min_value = 0
	value = $"../../Character".CurrentMeter
	$P2MeterLabel.text = str(value)

func _process(delta):
	value = $"../../Character".CurrentMeter
	$P2MeterLabel.text = str(value)
