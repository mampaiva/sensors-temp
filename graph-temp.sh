#!/bin/bash

echo "último registro:" 
tail -n 1 temp.dat
echo "In the last 24h the maximum temperature was:" 
sort -n temp.dat | tail -n 1 | echo celsius degree

nl  -s '     ' temp.dat > sensors-data.dat

echo "set term postscript color enhanced \"Helvetica\" 20

set pointsize 1.4 
set key Left reverse

set mxtics 2
set mytics 2

set ylabel \"{/Helvetica-Bold=24 Temperature/C\"

set xrange[*:*]
set yrange[*:*]

set output \"sensors.ps\"
set key at graph 0.95, graph 0.45 vertical maxrows 7
set xlabel \"x10 seconds\" 

set label 1  \"\" at graph 0.16, graph 0.85
plot   \"sensors-data.dat\" index 0 u 1:2 w l lw 4 lc rgb \"black\" ti \"\" " >> sensors.gpl

gnuplot sensors.gpl &
atril sensors.ps &

sleep 2s

rm sensors.gpl
