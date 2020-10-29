#!/bin/bash
rm temp.dat

while :
do
    sensors | grep "Package id 0:  " >> temp.dat
    date >> temp.dat
	sleep 10
done
