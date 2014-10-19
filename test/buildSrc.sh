#!/bin/sh
#rm ./temp/* -f
#./makeSrc.py
rm ./bin/* -f
cp ./src/*.hs ./bin/
cd ./bin
for i in $(ls); do
	ghc --make -O2 $i
done
rm ./*.* -f
