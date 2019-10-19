#!/bin/sh
# ^ shebang: hw2-1

ls -ARSl | awk '$1=substr($1,0,1) {print $0}' | sed '1d' | awk '$1=="d" {totald += 1}; $1=="-" {totalf += 1} ; {totals += $5};NR < 6 {print NR ":" $5 "\t" $9}; END {print "Dir num:" totald "\nFile num:" totalf "\nTotal:" totals}'
