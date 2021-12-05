#!/bin/bash
MINDIFF=7
DCURR=`date +%Y%m%d`
for dir in `find -name "Backup-*-*-*"`
do
D=`echo $dir | awk -F "-" '{print $2$3$4}'`
let DIFF=(`date +%s -d $DCURR`-`date +%s -d $D`)/86400

if [[ $DIFF -lt $MINDIFF ]]
then 
	MINDIFF=$DIFF
	LASTDIR="$dir"
fi
done
DCURR=`date +%Y-%m-%d`
if [[ $MINDIFF -eq 7 ]]
then
	dirname=Backup-`date +%Y-%m-%d`
	mkdir "$dirname"
	echo "create $dirname `date +%F`" >> backup-report
	for file in source/*
	do
		cp  "$file" "$dirname"
		echo "copy `basename $file`" >> backup-report
	done
else
	LASTDIR=${LASTDIR:2}
	isUpdate="false"
	for file in source/*
	do
		filepath="$LASTDIR"/"`basename $file`"
		if [ -f "$LASTDIR"/"`basename $file`" ]
		then
			if [ `wc -c "$file" | awk {'print $1'}` != `wc -c "$filepath" | awk {'print $1'}` ]
			then
				mv "$filepath" "$filepath.$DCURR"
				cp "$file" "$LASTDIR"
				echo "update "`basename "$file"` `basename "$file"`.$DCURR >> tmp1
				isUpdate="true"
			fi
		else
			cp "$file" "$LASTDIR"
			echo "copy "`basename "$file"` >> tmp2
			isUpdate="true"
		fi
	done
	if [[ $isUpdate == "true" ]]
	then
		echo "updateDir $LASTDIR $DCURR" >> backup-report
		if [ -f tmp2 ]
		then
			cat tmp2 >> backup-report
			rm tmp2
		fi
		if [ -f tmp1 ]
		then
			cat tmp1 >> backup-report
			rm tmp1
		fi
	fi
fi
