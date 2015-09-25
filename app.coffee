SerialPort = require 'serialport'
Serialport = SerialPort.SerialPort
serialport = new Serialport '/dev/ttyUSB0',
  baudrate: 57600
  parser: SerialPort.parsers.readline '\n'

serialport.on 'open', ->
  serialport.write 'WHO AM I?\n', (err, results) ->

Mqtt = require 'mqtt'
mqtt = Mqtt.connect 'mqtt://test.mosquitto.org'

mqtt.on 'connect', ->
  mqtt.subscribe '/pdostalcz/#'

mqtt.on 'message', (topic, message) ->
  console.log topic.toString() + ' ' + message.toString()

serialport.on 'data', (data) ->
  if /^\[[0-9]+\] [A-Z]+-[0-9A-Z]+ .+$/g.test data
    sensor = data.replace /^\[[0-9]+\] ([A-Z]+-[0-9A-Z]+) .+$/g, '$1'
    data = data.replace /^\[[0-9]+\] [A-Z]+-[0-9A-Z]+ (.+)$/g, '$1'

    mqtt.publish '/pdostalcz/' + sensor.toLowerCase(), data

