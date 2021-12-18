#!/bin/bash

echo "$$" > .pid
bash follow.sh &

declare -a arr
i=0
while true
do
	for ((j=0; j < 10; j++))
	do
		let index=$i*10+$j
		arr[$index]=$j
	done
	if [ $(( $i % 100000 )) -eq 0 ]
	then echo ${#arr[@]} >> report.log
	fi
	let i=$i+1
done
