#!/usr/bin/python
import string, re
inF = open("output", "r")
newText = ""
for line in inF:
	newText = newText + line
inF.close()
data =  re.findall(r"=>\s(?P<program>.*?),\s(?P<try>\d*?)\s+Round:\s+(?P<round>\d*?)\s+\|\s+(?P<maxRounds>\d*?)\s+\((?P<movespersec>.*?)\.\d+/s\).*?Points:\s+(?P<points>\d*?)\s+\((?P<pointspermove>.*?)\.\d+/Move\).*?Best:\s+(?P<best>\d*?)\s+?",newText, re.M | re.S)
data.sort()
outF = open("dump", "w")
for tupel in data:
	print >> outF, ";".join([tupel[0], tupel[1], tupel[2], tupel[3], tupel [4], tupel[5].lstrip('0'), tupel[6], tupel[7]])
outF.close()
