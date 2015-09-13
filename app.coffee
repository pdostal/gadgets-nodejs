serialport = require 'serialport'
SerialPort = serialport.SerialPort

isEmpty = (str) ->
  !str or str.length == 0 or /^\s*$/.test(str) or !str.trim()

sp = new SerialPort '/dev/ttyUSB0',
  baudrate: 57600
  parser: serialport.parsers.readline '\n'

sp.on 'open', ->
  console.log 'Serial Port Opend'
  sp.on 'data', (data) ->
    if !isEmpty data
      console.log ': ' + data
  sp.write 'WHO AM I?\n', (err, results) ->

