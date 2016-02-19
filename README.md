[![Build Status](http://img.shields.io/travis/TheODI-UD2D/sir_handel.svg?style=flat-square)](https://travis-ci.org/TheODI-UD2D/sir_handel)
[![Dependency Status](http://img.shields.io/gemnasium/TheODI-UD2D/sir_handel.svg?style=flat-square)](https://gemnasium.com/TheODI-UD2D/sir_handel)
[![Coverage Status](http://img.shields.io/coveralls/TheODI-UD2D/sir_handel.svg?style=flat-square)](https://coveralls.io/r/TheODI-UD2D/sir_handel)
[![Code Climate](http://img.shields.io/codeclimate/github/TheODI-UD2D/sir_handel.svg?style=flat-square)](https://codeclimate.com/github/TheODI-UD2D/sir_handel)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://TheODI-UD2D.mit-license.org)

# Sir Handel

[![Train](https://farm1.staticflickr.com/41/76607175_d76b553995_z.jpg)](https://www.flickr.com/photos/tomloudon/76607175/)
(Photo by [Tomosaurus](https://www.flickr.com/photos/tomloudon/))

A visualisation platform for London Underground train signal data.

# What is it?

The platform consists of three parts

## Signal Graphs

Allows signal data to be viewed and compared on a time series graph. There is also an API that exposes signal data for a given time period in JSON format.

![Signal graph](/signal-screenshot.png)

URLs are in the following format:

* ``/signals(.json)`` - List of signals, grouped by theme
* ``/signals/{signal-name}/{from datetime}/{to datetime}(.json)`` - Graph or JSON representation for a given signal over a given time period
* ``/signals/{signal-name}/{from datetime}/{to datetime}(.json)?interval={1s|5s|10s|30s|1m|5m|10m|30m|1h|1d}`` - Graph or JSON representation for a given signal over a given time period, averaged over a given interval
* ``/signals/{signal-1},{signal-2}/{from datetime}/{to datetime}(.json)`` - Graph or JSON representation of a comparison view for two given signals over a given time period

All DateTimes must be in an [ISO8601](https://tools.ietf.org/html/rfc3339) DateTime format.

## Crowding data

Shows crowding data visualisations for train carriages due to arrive at a particular Victoria Line station at a given date and time, together with simulated data for subsequent trains.

![Signal graph](/crowding-screenshot.png)

URLs are in the following format:

* ``/stations`` - Lists all the stations, northbound and southbound
* ``/stations/arriving/{northbound|southbound}/{station}(.json)`` - Data or a visualisation for the current time on 23rd September 2015. The HTML version advances automatically every 30 seconds
* ``/stations/arriving/{northbound|southbound}/{station}/{datetime}(.json)`` - Data or a visualisation for a given datetime. The HTML version advances automatically every 30 seconds

All DateTimes must be in an [ISO8601](https://tools.ietf.org/html/rfc3339) DateTime format.

## Heatmap

Simulated data and visualisation that shows the occupancy of the Victoria line network at a given date and time, expressed.

![Signal graph](/heatmap-screenshot.png)

URLs are in the following format:

* ``/heatmap(.json)`` - Shows the occupancy of the network for the current time on 23rd September 2015
* ``/heatmap/{datetime}(.json)`` - Shows the occupancy of the network for for a given datetime

All DateTimes must be in an [ISO8601](https://tools.ietf.org/html/rfc3339) DateTime format.

# Dependencies

* Ruby (> 2.2.3)
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) (= 2.0.0)
* Elasticsearch data in the [correct format](#data_format)

# Installation

## Clone the repo:

```
git clone https://github.com/TheODI-UD2D/sir_handel.git
```

## Install Ruby Dependencies:

```
bundle install
```

## Set environment variables

Create a new file called `.env` and enter the variables in the following format:

```
ES_URL: {the url to your elasticsearch instance - probable http://localhost:9292 if you're working locally}
ES_INDEX: {the name of the index that contains your data}
```

If you want to add http basic auth to your installation, you can also add the following variables:

```
TUBE_USERNAME: {some username}
TUBE_PASSWORD: {some password}
```

We also use [Memcachier](https://www.memcachier.com/) in production for caching. If you have a Memcachier account,
you can also add your credentials

```
MEMCACHIER_USERNAME: {your memchachier username}
MEMCACHIER_PASSWORD: {your memchachier password}
MEMCACHIER_SERVERS: {your memchachier servers (comma seperated)}
```

## Start the server

```
bundle exec rackup
```

The server will then be running at ``http://localhost:9292``

# Data Format

The Elasticsearch database should be set up with the following mappings:

```JSON
{
  "train_sample": {
    "properties": {
      "timeStamp": {
        "format": "strict_date_optional_time||epoch_millis",
        "type": "date"
      },
      "signalName": {
        "index": "not_analyzed",
        "type": "string"
      },
      "runLengthMs": {
        "type": "long"
      },
      "memoryAddress": {
        "index": "not_analyzed",
        "type": "string"
      },
      "vcuNumber": {
        "type": "integer"
      },
      "bits": {
        "type": "integer"
      },
      "vcu": {
        "index": "not_analyzed",
        "type": "string"
      },
      "id": {
        "type": "string"
      },
      "trainNumber": {
        "type": "integer"
      },
      "value": {
        "type": "integer"
      }
    }
  }
}
```

An example document looks like this:

```JSON
{
  "id": "03042E4414AW-178888437906",
  "trainNumber": 0,
  "signalName": "@.MWT.CT_CI_T2_1.UCOD4_I_MLC20.CI_COP_XU_Ln",
  "memoryAddress": "2E4414AW",
  "bits": 16,
  "value": 6377,
  "timeStamp": "2015-09-02T11:13:57.906Z",
  "vcuNumber": 304,
  "runLengthMs": 0
}
```

Each field is defined as follows:

| Field Name      | Definition |
|-----------------|------------|
| `id`            | A unique ID for the document |
| `trainNumber`   | The Number of the train. Currently this is 0 for all cases |
| `signalName`    | The internal name of the signal - A list of possible signal names, memory addresses and aliases can be [seen in CSV format here](config/sources/signals.csv) |
| `memoryAddress` | The memory address of the signal - see the [sources CSV for a lookup](config/sources/signals.csv) |
| `bits`          | The number of bits the `value` is stored in |
| `value`         | The value that the signal has recorded at that given time - see the [sources CSV for what that value represents](config/sources/signals.csv) |
| `timeStamp`     | The DateTime that the `value` was recorded |
| `vcuNumber`     | The number of the carriage. This is 304 for all cases currently |
| `runLengthMs`   | ???? |
