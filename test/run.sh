#!/bin/sh
echo "------building src------"
./buildSrc.sh
echo "------starting Tests------"
./doTests.sh $1
echo "parsing Results"
./parser.py
echo "scoring Results"
./score.py
