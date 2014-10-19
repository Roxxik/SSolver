#!/usr/bin/python
inF = open ("./src/solverSrc00.hs", "r")
src = []
for line in inF:
	src.append(line)
inF.close()
for i in range(3):
	for j in range(2,4):
		outF = open("./temp/solver%s%s.hs" % (i,j),"w")
		for line in src:
			print >> outF, line,
		print >> outF, "rekurScoreMethod = %s\nrekurDepth = %s" % (i,j)
		outF.close()



#rekurScoreMethod = 2
#rekurDepth = 8
