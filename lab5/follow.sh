#!/bin/bash

proc=`cat .pid`
while [ -d /proc/$proc ]
do
	top -b -n 1 > top.txt
	cat top.txt | grep -E "^MiB Mem" >> fmem
	cat top.txt | grep -E "^MiB Swap" >> fswap
	cat top.txt | grep -E "$proc" >> fproc
	sleep 1
done

