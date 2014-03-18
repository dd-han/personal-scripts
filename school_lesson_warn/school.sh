#!/bin/bash
BRW_UA="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"
BRW_POST="show_select6=3&show_select7=3&show_radio=8&show_select8=4&Submit=%A1%40%A4U%A1%40%A4%40%A1%40%A8B%A1%40"
BRW_REF="https://academic.nutc.edu.tw/curriculum/show_subject/show_subject_form.asp"
ENC_CONV="iconv -f big5 -t utf8"
SAV_COOKIE="cookie.txt"
SAV_DIFF="diff.txt"
MSG_SUB="緊急事態！ 選課系統發生異變"
MAL_to="han@dd-han.tw"
MAL_FRM="j28347846@gmail.com"
MAL_ACC="j28347846"
MAL_PAS="bmjearnexmzedmur"
#FOR_CONV="grep table | sed s/\<\\/tr\>/\\n/g | sed s/\<\\/td\>/\\t/g | sed -e :a -e 's/<[^>]*>//g;/</N;//ba'"

function make_msg(){
	SAV_MSG="msg_$SAV_DATE.txt"
	
	echo "選課系統發生了變化，很有可能有新的課程可以選擇。" > $SAV_MSG
	echo "" >> $SAV_MSG
	echo "立即前往選課系統選課 https://academic.nutc.edu.tw/registration/Verifyv2.asp?Ticket=BA03FBF0B2D7EA5B13625815CD1E5019261E4B19BA6CFD5EF1610F23D85733FAE7CCE06A2AD6D8A1" >> $SAV_MSG
	echo "" >> $SAV_MSG
	echo "以下是diff報告：" >> $SAV_MSG
	echo "-----------------------------------------------------------------------------" >> $SAV_MSG
	cat $SAV_DIFF >> $SAV_MSG
	echo "-----------------------------------------------------------------------------" >> $SAV_MSG

	./smtp-cli.perl --host smtp.gmail.com --port 587 --user "${MAL_ACC}" --auth-plain --password "${MAL_PAS}" --from "${MAL_FRM}" --to "${MAL_to}" --subject "$MSG_SUB" --body-plain "$(cat $SAV_MSG)"
}


function get_check(){
	# Create Filenames
	SAV_DATE=$(date "+%Y%m%d_%H%M%S")
	SAV_FILE="lesson_$SAV_DATE.cvs"
	SAV_FILE_LN="LastFile.txt"
	SAV_FILE_Last=""
	
	#if [ -d school ]; then 
	#	echo 
	#else
	#	mkdir school
	#fi
	
	# Get Webpage and Convert to cvs format
	curl https://academic.nutc.edu.tw/curriculum/show_subject/show_subject_form.asp -D $SAV_COOKIE  -A "$BRW_UA" > /dev/null
	curl https://academic.nutc.edu.tw/curriculum/show_subject/check_show_select.asp -b $SAV_COOKIE -D $SAV_COOKIE -A "$BRW_UA" -d "$BRW_POST" -e "$BRW_REF" > /dev/null
	curl https://academic.nutc.edu.tw/curriculum/show_subject/show_subject_choose_common.asp -b $SAV_COOKIE  -A "$BRW_UA" -e "$BRW_REF" | $ENC_CONV | \
	grep table | sed s/\<\\/TR\>/\\n/g | sed s/\<\\/TD\>/\\t/g | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed s/學期\\t//g | sed s/教學大綱\\t//g | sed s/提供\\t//g | \
	grep -e "通識" -e "通識二２" -e "學制" > $SAV_FILE
	
	# Clean Cookie
	rm $SAV_COOKIE

	# Compare two Diff version If Avalaiable
	if [ -f $SAV_FILE_LN ]; then 
		echo comparing...
		SAV_FILE_Last=$(cat $SAV_FILE_LN)
		diff $SAV_FILE $SAV_FILE_Last > $SAV_DIFF
		# When Compare finished , File is not in need
		rm $SAV_FILE_Last

		# if find some difference, Send Mail and Alert by Sound
		if [ "$(cat $SAV_DIFF)" != "" ] ; then
			echo 偵測到不同!!!!
			echo $'\07'
			cat $SAV_DIFF
			make_msg
		fi
		rm $SAV_DIFF
	fi
	
	# Save this tims's Filename for next time Compare
	echo $SAV_FILE > $SAV_FILE_LN
	
}



echo Check start.

while [ "a" == "a" ]
do

get_check
sleep 10

done
