#!/bin/bash
if [ -z "$1" ] && [ -z "$2" ]
    then
        echo "Usage: generate.sh {row size} {row number}"
        exit
fi 

if [ -z "$3" ]
    then
        tempfname="temp.json"
    else
        tempfname=$3
fi

for i in $( eval echo {0..$1} )
do
   echo "Generating tile $i"

   yq -o json -P ".parameterSets.atile.onlyX=\"$i\", .parameterSets.atile.onlyY=\"$2\"" generate.json > $tempfname

   
    /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD hex.scad -P atile -p $tempfname -o tile-row$2-$i.stl
done
rm $tempfname