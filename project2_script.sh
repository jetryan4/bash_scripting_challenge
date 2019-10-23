#!/bin/sh
#FILE_END=1
FILE_OPT="./data/opt/bout"
FILE_HUE="./data/heu/hout"
>"summary"
for i in {1..9}
do
    >"holder$i"
    optfile="${FILE_OPT}${i}"
    heufile="${FILE_HUE}${i}"
    while IFS= read -r entry_name
    do
	read -r entry_value
	read -r 
	#echo "I am on the command $entry_name"
	if grep -q $entry_name "$heufile"; then
	    FOUND=$(grep -A1 -w $entry_name "$heufile"|grep -v $entry_name)
	    subtracted="$(echo "$FOUND - $entry_value" | bc)"
	    #echo "The difference between the heu - opt = $subtracted"
	    echo "$subtracted" >> "holder$i"
       	else
	    echo "The item  $entry_name, with value $entry_value was not found in $heufile"
	fi
    done < "$optfile"

    if [ -s "holder$i" ]; then
	avgval=$(awk '{ total += $1; count++ } END { print total/count }' "holder$i")
	minval=$(cut -f1 "holder$i"| sort -n | head -1)
	maxval=$(cut -f1 "holder$i" | sort -n | tail -1)
	echo "$i, hout$i/bout$i, $avgval, $minval, $maxval" >> "summary"
    else
	echo "$i, hout$i/bout$i, 0, 0, 0" >> "summary"
    fi   
done
