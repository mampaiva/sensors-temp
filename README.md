# sensors-temp
monitor CPU temperature

requirements

sudo apt install atril lm-sensors gnuplot

First run the temp.sh script in backgroud, if had any poweroff or you want to check the historic of cpu temperatures run graph-temp.sh script.

the script record the temperature of CPU package every 10 seconds.

For purposes the save space, every 24 h the temperature data will be erased and the last 2 minutes  and the maximum temperature will be remains.
