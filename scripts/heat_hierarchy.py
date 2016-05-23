#!/usr/bin/python

import re
import sys

id2name = {}
lines = [l.rstrip() for l in sys.stdin]
for line in lines:
#    print(line)
#    line = line.rstrip()
    if re.match(r'^ID', line): continue
    (uuid,name,parent) = line.split(',')
#    print "%s: [%s] <- %s" % (uuid, name, parent)
#    id2name[uuid] = name
    id2name[uuid] = re.sub(r'-', '-\\\\n', name)

print("""
digraph graph_name {
graph [
  rankdir = BT
  layout = fdp
];
node [
  style = filled,
  shape = box,
  fillcolor = "#fffece",
  fontname = "Migu 1M"
];
""")
for line in lines:
    if re.match(r'^ID', line): continue
    (uuid,name,parent) = line.split(',')
    if parent == '': continue
#    re.sub(r'^overcloud-', '', name)
    print('"%s" -> "%s"' % (id2name.get(uuid), id2name.get(parent)))

print("}")
