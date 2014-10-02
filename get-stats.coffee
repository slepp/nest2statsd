Firebase = require 'firebase'
lynx = require 'lynx'

config = require('./config.json')

metrics = new lynx(config.statsd?.host ? 'localhost',config.statsd?.port ? 8125)

ref = new Firebase 'wss://developer-api.nest.com'
ref.auth config.access_token

ref.on 'value', (snapshot) ->
  data = snapshot.val()
  for id, thermo of data.devices.thermostats
    console.log thermo
    metrics.gauge (config.prefix ? 'nest-api')+'.ambient_temperature_c', thermo.ambient_temperature_c
    metrics.gauge (config.prefix ? 'nest-api')+'.target_temperature_c', thermo.target_temperature_c
