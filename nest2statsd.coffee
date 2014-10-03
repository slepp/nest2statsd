Firebase = require 'firebase'
lynx = require 'lynx'

config = require('./config.json')

metrics = new lynx(config.statsd?.host ? 'localhost',config.statsd?.port ? 8125)

hvacMap =
  "off":       0
  "heat":      1
  "heat-cool": 2
  "cool":      3
  "range":     4

ref = new Firebase 'wss://developer-api.nest.com'
ref.auth config.access_token

ref.on 'value', (snapshot) ->
  data = snapshot.val()
  metricData = {}
  for id, structure of data.structures
    structureName = structure.name?.replace(/[^A-Za-z0-9]+/g, '_').replace(/_+/g, '_').replace(/_$/, '') ? 'structure'
    metricData[(config.prefix ? 'nest-api') + "." + structureName + ".away"] = if structure.away == 'home' then 0 else 1

    for id in structure.thermostats
      thermo = data.devices.thermostats[id]
      metricName = (config.prefix ? 'nest-api') + "." + structureName + "." + thermo.name.replace(/[^A-Za-z0-9]+/g, '_').replace(/_+/g, '_').replace(/_$/, '')
      console.log new Date().toString() + " " + metricName + " " + thermo.ambient_temperature_c + " " + thermo.target_temperature_c

      keysToStore = ['ambient_temperature','target_temperature','target_temperature_low','target_temperature_high','away_temperature_low','away_temperature_high']
      keyTempSuffix = if thermo.temperature_scale == 'C' then "_c" else "_f"
      for key of keysToStore
        keysToStore[key] += keyTempSuffix

      for key in keysToStore
        if thermo[key] < 0.0
          # We need to set the gauge to 0 before we can go negative
          console.log "Negative"
          #metrics.gauge(metricName + "." + key, 0)
        metricData[metricName + "." + key] = thermo[key] + "|g"

      metricData[metricName + ".hvac_mode"] = hvacMap[thermo.hvac_mode] ? -1
      metricData[metricName + ".has_leaf"] = if thermo.has_leaf == true then 1 else 0
      metricData[metricName + ".is_using_emergency_heat"] = if thermo.is_using_emergency_heat then 1 else 0

      console.log metricData

      metrics.send(metricData)
