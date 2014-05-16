#!/usr/bin/env python

import re
import csv
import json

stations = {}
name_match = re.compile('^[SU] ')
bus_match = re.compile('\\[Bus.*\\]$')

with open('stops.txt', 'r') as csvfile:
  stops_reader = csv.reader(csvfile, delimiter=',')
  for row in stops_reader:
    hafas_idx = 0
    name_idx = 2
    lat_idx = 4
    lon_idx = 5
    name = row[name_idx]

    # skip non U- or S-Bahn stations
    if not name_match.search(name) or bus_match.search(name):
      continue

    # remove obsolete ' (Berlin)' string from station names
    if re.search(' \\(Berlin\\)$', name):
      idx = len(name)- len(' (Berlin)')
      name = name[0:idx]

    stations[row[hafas_idx]] = {
        "id": row[hafas_idx],
        "name": name,
        "latitude": row[lat_idx],
        "longitude": row[lon_idx],
    }

with open('transfers.txt', 'r') as csvfile:
  transfers_reader = csv.reader(csvfile, delimiter=',')
  for row in transfers_reader:
    stop_a = row[0]
    stop_b = row[1]
    try:
      if stations[stop_a] and stations[stop_b]:
        try:
          stations[stop_a]['adjacent_stops'].append(stations[stop_b]['id'])
        except:
          stations[stop_a]['adjacent_stops'] = [stations[stop_b]['id']]
          
        try:
          stations[stop_b]['adjacent_stops'].append(stations[stop_a]['id'])
        except:
          stations[stop_b]['adjacent_stops'] = [stations[stop_a]['id']]
    except:
      pass

print json.dumps({"stops": [stations[id] for id in stations]})
