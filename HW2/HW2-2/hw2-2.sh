#!/bin/sh
RESULT=/tmp/menu.sh.$$
NETCH=/tmp/netchoice.sh.$$
FILE=/tmp/allfile.sh.$$
x=$(sysctl vm.kmem_size | cut -d" " -f2)
y=$(sysctl vm.kmem_map_size | cut -d" " -f2)
z=$((y*100/x))
menu(){
	dialog --title "HW2-2_0513404" --menu "SYS INFO" 12 36 6\
	1 "CPU INFO" 2 "MEMORY INFO" 3 "NETWORK INFO" 4 "FILE BROWSER"\
	2> "${RESULT}"
	ch=$( cat $RESULT)
	case $ch in
		1) cpu;;
		2) mem;;
		3) net;;
		4) file;;
	esac
	[ -f $RESULT ] && rm $RESULT
}
cpu(){
	dialog --title "CPU Info" --msgbox \
	"$(sysctl hw.model hw.machine hw.ncpu)" \
	12 72
	result=$?
	if [ $result -eq 0 ] ; then
		menu
	fi
}
mem(){
	while true
	do
		read -es | dialog --title "Memory Info" --gauge \
		"$(sysctl vm.kmem_size vm.kmem_map_size vm.kmem_map_free | \
		cut -d" " -f2 | awk 'NR == 1 {print "Total:"}; \
		NR == 2 {print "Used:"}; NR == 3 {print "Free:"}; \
		{ split( "B KB MB GB TB" , v ); unit=1; \
		while( $1>1024 ){$1/=1024; unit++ }print $1,v[unit] }')" \
		12 72 $z
		read -t1 ans
		if [ $? -eq 0 ]
		then
			break
		fi
	done
	menu
}
net(){
	cc=$(ifconfig -l | wc -w | sed 's/[[:space:]]//g')
	i=0
	set -f
	dialog --title "HW2-2_0513404" --menu "Network Interfaces" 12 36 6 \
	$(ifconfig -l | xargs -n1 | awk '{print $1 " *"}') \
	2> "${NETCH}"
	netch=$( cat $NETCH)
	[ $netch != "" ] && device_info
	menu
}
device_info(){
	dialog --title "" --msgbox \
	"$(ifconfig $netch | grep -E "ether|inet " | xargs -n2 | \
	awk 'NR==1 {print "IPv4___:" $2};NR==2 {print "Netmask:" $2};\
	NR==3 {print "Mac____:" $2}')" 12 72
	[ -f $NETCH ] && rm $NETCH
	net
}
file(){ 
	nn=$(ls -al | awk '{print $9}'|sed '1d' |wc -w)
	dialog --title "" --menu "File Browser:$(pwd)" 25 72 12\
	$(ls -al | awk '{print $9}' | sed '1d' | \
	xargs -I % file --mime-type % | xargs -n2) \
	2>"${FILE}"
	chfile=$(cat $FILE)
	chfile2=$(cat $FILE | sed 's/.$//')
	echo "chfile:$chfile"
	[ -f $FILE ] && rm $FILE
	ft=$(echo "$chfile"| sed 's/.$//' | xargs -I % file --mime-type % |\
	awk '{print $2}'| grep "text")
	ft2=$(echo "$chfile"| sed 's/.$//' | xargs -I @ file --mime-type @ |\
	awk '{print $2}'| grep "inode")
	if [ $chfile != "" ] ; then
		if [ $ft2 != "" ] 
		then
			cdto
		else
			if [ $ft != "" ]
			then
				textinfo
			else
				notextinfo
			fi
		fi
	fi
	menu
}
textinfo(){
	f1=$(echo "$chfile")
	f2=$(echo "$chfile"|sed 's/.$//')
	dialog --title "" --no-label "Edit" --yesno \
	" <File Name>: $(echo "$f1" | sed 's/.$//' | xargs -I % du -sh % |\
	awk '{print $2 }')\n <File Info>: $(echo "$f1"|\
	sed 's/.$//' | xargs -I @ file --mime-type @ | awk '{print $2}')\n\
	<File Size>: $(echo "$f2" | xargs -I size du -sh size|\
	awk '{print $1}')"\
	12 72
	ynresult=$?
	if [ $ynresult -eq 1 ] ; then
	$EDITOR $f2
	elif [ $ynresult -eq 255 ] ; then
	exit 255;
	fi
	file
	
}

notextinfo(){
	fl=$(echo "$chfile")
	f2=$(echo "$chfile")
	dialog --title "" --msgbox \
	" <File Name>: $(echo "$fl" | sed 's/.$//' | xargs -I % du -sh % |\
	awk '{print $2 }')\n <File Info>: $(echo "$fl"|\
	sed 's/.$//' | xargs -I @ file --mime-type @ | awk '{print $2}')\n\
	<File Size>: $(echo "$f2" |sed 's/.$//' | xargs -I size du -sh size|\
	awk '{print $1}')"\
	12 72
	file
}
cdto(){
	cd $chfile2
	file
}

menu

