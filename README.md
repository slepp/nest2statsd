nest2statsd
===========

This utility will grab Nest Thermostat data from their API and send it
to your own StatsD for graphing.

To get started, copy the config.example.json to config.json and enter in
your access_token into the configuration. Once that's there, simply start
the get-stats.coffee inside Node, and it will start a data stream to StatsD
as Nest sends updates.
