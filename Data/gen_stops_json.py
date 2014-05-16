#!/usr/bin/env python

import re
import csv
import json

stations = {}
name_match = re.compile('^[SU][+ ]')
bus_match = re.compile('\\[Bus.*\\]$')

stations_lines = {}
stations_ids = {}
line_stops = json.load(open('line_stops.json', 'r'))
for line in line_stops:
  for station in line_stops[line]:
    try:
      stations_lines[station].append(line)
    except:
      stations_lines[station] = [line]

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

    (prefix, name_idx) = name.split(' ', 1)
    if prefix != 'U' and prefix != 'S' and prefix != 'S+U':
      name_idx = prefix + name_idx
      prefix = "null"


    stations_ids[name_idx] = row[hafas_idx]
    stations[row[hafas_idx]] = {
        "id": row[hafas_idx],
        "type": prefix,
        "name": name_idx,
        "latitude": row[lat_idx],
        "longitude": row[lon_idx],
        "adjacent_stops": [],
    }
    try:
      lines = stations_lines[name_idx]
      stations[row[hafas_idx]]['lines'] = lines
    except:
      pass


for i,s in stations.items():
  name_idx = s['name']
  try:
    for line in s['lines']:
      line_idx = line_stops[line].index(name_idx)
      if line_idx == 0:
        asn = line_stops[line][line_idx+1]
        aid = stations_ids[asn]
        if aid:
          stations[i]['adjacent_stops'].append(aid)
      elif line_idx == len(line_stops[line]):
        psn = line_stops[line][line_idx-1]
        pid = stations_ids[psn]
        if pid:
          stations[i]['adjacent_stops'].append(pid)
      else:
        asn = line_stops[line][line_idx+1]
        psn = line_stops[line][line_idx-1]
        aid = stations_ids[asn]
        pid = stations_ids[psn]
        if aid:
          stations[i]['adjacent_stops'].append(aid)
        if pid:
          stations[i]['adjacent_stops'].append(pid)
  except:
    pass #print 'no lines:', s['name']

if False:
  with open('transfers.txt', 'r') as csvfile:
    transfers_reader = csv.reader(csvfile, delimiter=',')
    for row in transfers_reader:
      stop_a = row[0]
      stop_b = row[1]
      try:
        if stations[stop_a] and stations[stop_b] and stations[stop_a] != stations[stop_b]:
          try:
            stations[stop_a]['adjacent_stops'] = list(set(stations[stop_a]['adjacent_stops']).union([stations[stop_b]['id']]))
          except:
            stations[stop_a]['adjacent_stops'] = [stations[stop_b]['id']]

          try:
            stations[stop_b]['adjacent_stops'] = list(set(stations[stop_b]['adjacent_stops']).union([stations[stop_a]['id']]))
          except:
            stations[stop_b]['adjacent_stops'] = [stations[stop_a]['id']]
      except:
        pass

print json.dumps({"stops": [stations[id] for id in stations]})
