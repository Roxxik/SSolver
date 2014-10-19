#!/usr/bin/python
import re
inF = open("dump", "r")
i = -1
db = []
temp = ""
progPattern = re.compile(r"\A(\w+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+)")
#(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+)\Z
for line in inF:
	progMatch = progPattern.match(line)
	prog = progMatch.group(1)
	if temp == prog:
		db[i].append(progMatch.group(1,2,3,4,5,6,7,8))
	else:
		temp = prog
		db.append([progMatch.group(1,2,3,4,5,6,7,8)])
		i += 1
inF.close()
del prog
outF = open ("result", "w")
print >> outF, "name, Attempt, avgRound, maxRound, highRound, avg mps, max mps avgScore, maxScore, avg ppm, max ppm, avgTile, maxTile"
for prog in db:
	name = prog [0][0]
	maxAttempt = len(prog)
	sumRound = 0
	maxRound = 0
	highRound = int(prog[0][3])
	sumMps = 0
	maxMps = 0
	sumScore = 0
	maxScore = 0
	sumPpm = 0
	maxPpm = 0
	sumTile = 0
	maxTile = 0
	for i in range(0,len(prog)):
		sumRound += int(prog[i][2])
		maxRound = max(maxRound, int(prog[i][2]))
		sumMps += int(prog[i][4])
		maxMps = max(maxMps, int(prog[i][4]))
		sumScore += int(prog[i][5])
		maxScore = max(maxScore, int(prog[i][5]))
		sumPpm += int(prog[i][6])
		maxPpm = max(maxPpm, int(prog[i][6]))
		sumTile += int(prog[i][7])
		maxTile = max(maxTile, int(prog[i][7]))
	avgRound = sumRound/maxAttempt
	avgMps = sumMps/maxAttempt
	avgScore = sumScore/maxAttempt
	avgPpm = sumPpm/maxAttempt
	avgTile = sumTile/maxAttempt
	print >> outF, name, "\t",
	print >> outF, maxAttempt, "\t",
	print >> outF, avgRound, "\t",
	print >> outF, maxRound, "\t",
	print >> outF, highRound, "\t",
	print >> outF, avgMps, "\t",
	print >> outF, maxMps, "\t",
	print >> outF, avgScore, "\t",
	print >> outF, maxScore, "\t",
	print >> outF, avgPpm, "\t",
	print >> outF, maxPpm, "\t",
	print >> outF, avgTile, "\t",
	print >> outF, maxTile
outF.close()
