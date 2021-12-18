#!/bin/bash

echo "Number of users:" `ps -axu | tail -n +2 | awk {'print $1'} | sort | uniq | wc -l`
ps -axu | tail -n +2 | awk {'print $1'} | sort | uniq | while read line
do
echo "$line:" `ps -axu | awk {'print $1'} | grep -Ec "$line"`
done
