#!/bin/bash
LIST='/home/dd-han/git/personal-scripts/autoPull/test.csv'

totalLine=`wc -l $LIST | cut -d ' ' -f 1`

for i in `seq 1 $totalLine`;do
	line=`sed -n "${i},${i}p" "$LIST"`
	if echo $line | grep -v '^#'> /dev/null;then
		acc=`echo $line | cut -d ',' -f 1`
		path=`echo $line | cut -d ',' -f 2`
		cmd=`echo $line | cut -d ',' -f 3`

		echo $acc $path $cmd
		su ${acc} -c "cd ${path} && ${cmd} "
		#su ${acc} -c "cd ${path} \&\& ${cmd}"
	fi
done

