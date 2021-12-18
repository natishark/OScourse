#!/bin/bash

proc=`cat .pid`
proc2=`cat .pid2`
while [ -d /proc/$proc ] || [ -d /proc/$proc2 ]
do
	top -b -n 1 > top.txt
	cat top.txt | grep -E "^MiB Mem" >> fmem
	cat top.txt | grep -E "^MiB Swap" >> fswap
	cat top.txt | grep -E "$proc" >> fproc
	cat top.txt | grep -E "$proc2" >> fproc2
	sleep 1
done

