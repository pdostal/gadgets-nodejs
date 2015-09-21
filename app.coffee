isEmpty = (str) ->
  !str or str.length == 0 or /^\s*$/.test(str) or !str.trim()

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
  mqtt.publish '/pdostalcz/gadgets', 'Hello MQTT'

mqtt.on 'message', (topic, message) ->
  console.log topic.toString() + ' ' + message.toString()

serialport.on 'data', (data) ->
  if !isEmpty data
    data = data.replace /^(\[[0-9]+\] )/g, '/dev/ttyUSB0 '

    data = data.replace /AC-82/g, 'relay'
    data = data.replace /JA-80L/g, 'siren'
    data = data.replace /AC-88/g, 'powersocket'
    data = data.replace /RC-86K/g, 'controller'
    data = data.replace /TP-82N/g, 'thermometer'
    data = data.replace /JA-85ST/g, 'smokesensor'
    data = data.replace /JA-82SH/g, 'shakesensor'
    data = data.replace /JA-83M/g, 'magnetsensor'
    data = data.replace /JA-83P/g, 'motionsensor'
    data = data.replace /JA-81M/g, 'interface'

    mqtt.publish '/pdostalcz/gadgets', data
    console.log data

