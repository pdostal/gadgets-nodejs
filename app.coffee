isEmpty = (str) ->
  !str or str.length == 0 or /^\s*$/.test(str) or !str.trim()

sensorReplace = (str) ->
  if /^.+AC-82.+$/g.test str
    str.replace /^.+AC-82.+$/g, 'relay'
  else if /^.+JA-80L.+$/g.test str
    str.replace /^.+JA-80L.+$/g, 'siren'
  else if /^.+AC-88.+$/g.test str
    str.replace /^.+AC-88.+$/g, 'socket'
  else if /^.+RC-86K.+$/g.test str
    str.replace /^.+RC-86K.+$/g, 'control'
  else if /^.+TP-82N.+$/g.test str
    str.replace /^.+TP-82N.+$/g, 'thermostat'
  else if /^.+JA-85ST.+$/g.test str
    str.replace /^.+JA-85ST.+$/g, 'smokesensor'
  else if /^.+JA-82SH.+$/g.test str
    str.replace /^.+JA-82SH.+$/g, 'shakesensor'
  else if /^.+JA-83M.+$/g.test str
    str.replace /^.+JA-83M.+$/g, 'magneticsensor'
  else if /^.+JA-83P.+$/g.test str
    str.replace /^.+JA-83P.+$/g, 'movementsensor'
  else if /^.+JA-81M.+$/g.test str
    str.replace /^.+JA-81M.+$/g, 'universalinterface'
  else
    'rpi'

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
  if !isEmpty data
    sensor = sensorReplace data
    data = data.replace /(\[[0-9]+\] [A-Z]+-[0-9A-Z]+ )/g, ''

    mqtt.publish '/pdostalcz/' + sensor, data

