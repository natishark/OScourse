#!/bin/bash

DCURR=`date +%Y%m%d`
i=0
for dir in `find -name "Backup-*-*-*"`
do
	D=`echo "$dir" | awk -F "-" '{print $2$3$4}'`
	let DIFF=(`date +%s --date $DCURR`-`date +%s --date $D`)/86400
	if [[ $i -eq 0 ]]
	then
		MINDIFF=$DIFF
		LASTDIR="$dir"
	fi
	if [[ $DIFF -lt $MINDIFF ]]
	then
		MINDIFF=$DIFF
		LASTDIR="$dir"
	fi
	let i=$i+1
done
TARGET=/home/user/restore
mkdir $TARGET
for file in "$LASTDIR"/*
do
	ok="false"
	if [[ `echo $(basename "$file") | grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}$" | wc -l` -ne 0 ]]
	then
	version=`echo $(basename "$file") | grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}$" | tail -1`
	nversion=${version%.*}
	num=`ls "$LASTDIR" | grep -E "$nversion$" | wc -l`
	if [[ $num -eq 0 ]]
	then ok="true"
	fi
	else ok="true"
	fi
	if [[ $ok == "true" ]]
	then cp "$file" $TARGET
	fi
done

