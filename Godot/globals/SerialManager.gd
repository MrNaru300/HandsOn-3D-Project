extends Node

@export var port := "/dev/ttyACM0"
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
	if len(buffer) > 8096: buffer.substr(len(data))
	buffer += data.get_string_from_ascii().replace("\n", "")

	for line in buffer.split(",", false):
		var sensor := Sensor.from_str(line)
		if sensor == null: 
			printerr("Error while parsing new sesnor packet: ", line.c_escape())
			continue
		if sensors.get(sensor.id) == null:
			printerr("Uknown sensor: ", sensor, " from: (", line.c_escape(), ")")
			continue
			
		update_sensor(sensor)
	var pos = buffer.rfind(",")
	buffer = buffer.substr(pos) if pos != -1 else ""
	

func update_sensor(sensor: Sensor):
	
	sensors[sensor.id] = sensor
	sensor_update.emit(sensor)

func start_serial(port: String):
	if !serial.closed: 
		serial.close()
	serial.open(port)
	serial.flush_input()
	print("Trying to connect to serial: %s" % "true" if serial.is_open() else "false")

func _ready() -> void:
	serial.got_error.connect(_on_error)
	serial.data_received.connect(_on_data_received)
	serial.baudrate = baudrate
	serial.start_monitoring(2_000)
	
	start_serial(port)

func _exit_tree() -> void:
	serial.stop_monitoring()
	
	
