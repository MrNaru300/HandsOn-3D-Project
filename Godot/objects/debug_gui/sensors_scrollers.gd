extends HBoxContainer

@onready var id = %Label.text

func _ready() -> void:
	%Slider.value_changed.connect(_on_changed)
	

func _on_changed(value: float):
	var sensor := Sensor.new(id)
	sensor.pressure = value
	sensor.stretch = value
	SerialManager.update_sensor(sensor)
