serialport = require 'serialport'
SerialPort = serialport.SerialPort

isEmpty = (str) ->
  !str or str.length == 0 or /^\s*$/.test(str) or !str.trim()

sp = new SerialPort '/dev/ttyUSB0',
  baudrate: 57600
  parser: serialport.parsers.readline '\n'

sp.on 'open', ->
  sp.write 'WHO AM I?\n', (err, results) ->

  sp.on 'data', (data) ->
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

      console.log data

