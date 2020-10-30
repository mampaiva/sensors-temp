#!/bin/bash

    echo "temperature in celsius degree with the follow date and hour of the record:" > temp.dat

while :
do
    sensors | grep "Package id 0:  " | awk -F '[+]' '{print $2}' | awk -F '[.]' '{print $1}' >> temp.dat
    date >> temp.dat
	sleep 10
    a=`wc -l temp.dat | awk -F '[ ]' '{print $1}'`
    if [ $a -gt 17280 ]
    then
        echo "In the last 24h the maximum temperature was:" >> temp.dat
        sort -n temp.dat | tail -n 1 >> temp.dat
        tail -n 26 temp.dat > temp.dat.tmp
        rm temp.dat
        cat temp.dat.tmp > temp.dat
        rm temp.dat.tmp
    fi    
done
