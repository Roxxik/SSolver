#!/bin/bash
if [ -n "$1" ]; then
	(( Limit = $1 ))
else
	(( Limit = 10))
fi
for i in $(ls ./bin); do
	((a = 1))
	echo "running $i"
	while (( a <= Limit))
	do
		echo "test #$a"
		echo "=> $i, $a" >> output
		./gameclient.pyc --quiet --no-ansi -r 10000 -d 0 ./bin/$i >> output
		let "a+=1"
	done
done
