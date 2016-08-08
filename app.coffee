moment = require 'moment'

Serialport = require 'serialport'
serialpath = process.env.serialpath || '/dev/ttyUSB0'
serialport = new Serialport serialpath,
  baudrate: 57600
  parser: Serialport.parsers.readline '\n'

serialport.on 'open', ->
  serialport.write 'WHO AM I?\n', (err, results) ->

Mqtt = require 'mqtt'
mqtt = Mqtt.connect { host: 'iot.siliconhill.cz', port: 1883, protocolId: 'MQIsdp', protocolVersion: 3 }

mqtt.on 'connect', ->

serialport.on 'data', (data) ->
  mqtt.publish '/pdostalcz/ttyUSB0', data

  sensor = data.replace /^\[[0-9]+\] ([A-Z]+-[0-9A-Z]+) .+$/g, '$1'
  message = data.replace /^\[[0-9]+\] [A-Z]+-[0-9A-Z]+ (.+)$/g, '$1'

  if sensor == "TP-82N" and !/^SET:.+$/g.test message
    mqtt.publish '/pdostalcz/temp', message.replace(/INT:([-.0-9]*).C.*/g, '$1'), { retain: true }

  if sensor == "RC-86K" and /^ARM:0.+/g.test message
    mqtt.publish '/pdostalcz/btn', 'unlock', { retain: true }

  if sensor == "RC-86K" and /^ARM:1.+/g.test message
    mqtt.publish '/pdostalcz/btn', 'lock', { retain: true }

  if sensor == "JA-83P" and /^BEACON.+/g.test message
    mqtt.publish '/pdostalcz/move', 'beacon', { retain: true }

  if sensor == "JA-83P" and /^SENSOR.+/g.test message
    mqtt.publish '/pdostalcz/move', 'sensor', { retain: true }

  if sensor == "JA-85ST" and /^BEACON.+/g.test message
    mqtt.publish '/pdostalcz/smoke', 'beacon', { retain: true }

  if sensor == "JA-80L" and /^BEACON.+/g.test message
    mqtt.publish '/pdostalcz/beep', 'beacon', { retain: true }

