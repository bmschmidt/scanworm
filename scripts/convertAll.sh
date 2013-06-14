#!/usr/bin/sh

i=`grep -c 'model name' /proc/cpuinfo`
i=$(($i-2))
echo "Running with $i processors"

find pdfs -name "*.pdf" | xargs -n 1 -P $i sh scripts/convert.sh