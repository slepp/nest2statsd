nest2statsd
===========

This utility will grab Nest Thermostat data from their API and send it
to your own StatsD for graphing.

To get started, copy the config.example.json to config.json and enter in
your access_token into the configuration. Once that's there, simply start
the nest2statsd.coffee inside Node, and it will start a data stream to StatsD
as Nest sends updates.

Dependencies
============

This program uses Firebase and Lynx, which can be installed directly with `npm`. You will need a working StatsD/Graphite server set up to support the output from the script.

Quick Setup
===========

First, run:

    npm install

Copy config.example.json to config.json:

    cp config.example.json config.json
  
Edit config.json to set your `access_token`

Run the script:

    node /usr/bin/coffee ./nest2statsd.coffee
