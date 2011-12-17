#!/usr/bin/env python

import sys, io

header="""<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
"""

#	<key>AA</key>
#	<array>
#		<string>1.9900</string>
#		<string>1.9700</string>
#		<string>1.9200</string>
#		<string>2.1000</string>
#	</array>


footer="""</dict>
</plist>
"""

ff = open(sys.argv[1], 'r')
line = 'x'
print header
while line:
    line = ff.readline()
    tokens = [tt.strip() for tt in line.split(' ')]
    if len(tokens) > 2:
        if tokens[1] == 's':
            first = '%s%s' % (tokens[0], tokens[1])
            rest = tokens[2:]
            tokens = [first]
            tokens.extend(rest)
        print "   <key>%s</key>" % tokens[0]
        print "   <array>"
        for odds in tokens[1:]:
            print "        <string>%s</string>" % odds
        print "   </array>"
print footer
ff.close()

