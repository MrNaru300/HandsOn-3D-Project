extends Node

@export var port := "/dev/pts/0"
@export var baudrate := 9600
var serial := SerialPort.new()
var buffer = ""

signal sensor_update(sensor: Sensor)

var sensors = {}

func _init() -> void:
	for name in Sensor.Names.keys():
		sensors[name] = Sensor.new(name)

func _on_error(where, what) -> void:
	printerr("Got error when %s: %s" % [where, what])

func _on_data_received(data: PackedByteArray) -> void:
	buffer += data.get_string_from_ascii()
	var delim_pos = buffer.find(",")
	while delim_pos != -1:
		var sensor = Sensor.from_str(buffer.substr(0,delim_pos))
		buffer = buffer.substr(delim_pos+1)
		if sensor == null: 
			printerr("Error while parsing new sesnor packet")
			return
		if sensors.find_key(sensor.id) == -1:
			printerr("Uknown sensor: ", sensor.id)
			return
			
		update_sensor(sensor)
		delim_pos = buffer.find(",")
	

func update_sensor(sensor: Sensor):
	
	sensors[sensor.id] = sensor
	sensor_update.emit(sensor)

func start_serial(port: String):
	if !serial.closed: 
		serial.close()
	serial.open(port)
	print("Trying to connect to serial: %s" % "true" if serial.is_open() else "false")

func _ready() -> void:
	serial.got_error.connect(_on_error)
	serial.data_received.connect(_on_data_received)
	serial.start_monitoring(20_000)
	
	start_serial(port)
	
	
	
