extends HBoxContainer

@onready var id : String = %Label.text
@onready var slider : Slider = %Slider

func _ready() -> void:
	slider.value_changed.connect(_on_changed)
	SerialManager.sensor_update.connect(_on_sensor_update)
	
func _on_sensor_update(sensor: Sensor):
	if sensor.id != id: return
	
	slider.set_value_no_signal((sensor.get_position() + 1) * 512)
	

func _on_changed(value: float):
	var sensor := Sensor.new(id)
	sensor.pressure = value
	sensor.stretch = value
	SerialManager.update_sensor(sensor)
