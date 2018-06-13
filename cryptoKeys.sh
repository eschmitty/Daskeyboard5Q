#!/bin/bash

#set -x

##Sets infinite loop (CTRL+C to stop)
while :
do
	###Send API refresh token, create file with granted access token (.token.tok) and define $token variable
	curl -s -X POST -H "Content-Type: application/json" -d '{
		"client_id": "dV9SUNVImxRX99kb6bKdRfNaE",
		"refresh_token": "6bbd002f441ad515fbbc738ef714cea6",
		"grant_type": "refresh_token"
		}' https://q.daskeyboard.com/oauth/1.4/token | cut -d\" -f4 > /home/eschmitt/Daskeyboard5Q/.token.tok
	
	token=$(cat /home/eschmitt/Daskeyboard5Q/.token.tok)
	
	###Pull prices from CoinMarketCap API and store in files
	
	(for i in $(cat /home/eschmitt/Daskeyboard5Q/coinlist | egrep -v '\#')
	do
	curl -s -X GET 'https://api.coinmarketcap.com/v2/ticker/'$i'/?structure=array' | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' > /home/eschmitt/Daskeyboard5Q/.$i; 
	done)
	
	###Define 24h change value variables, create hundredth decimal place and remove decimal to create integer
	
	btc=$(cat /home/eschmitt/Daskeyboard5Q/.1 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	eth=$(cat /home/eschmitt/Daskeyboard5Q/.1027 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	ltc=$(cat /home/eschmitt/Daskeyboard5Q/.2 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	bch=$(cat /home/eschmitt/Daskeyboard5Q/.1831 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	xrp=$(cat /home/eschmitt/Daskeyboard5Q/.52 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	xlm=$(cat /home/eschmitt/Daskeyboard5Q/.512 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	ada=$(cat /home/eschmitt/Daskeyboard5Q/.2010 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	xmr=$(cat /home/eschmitt/Daskeyboard5Q/.328 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	burst=$(cat /home/eschmitt/Daskeyboard5Q/.573 | bc -l | xargs printf "%.2f" | sed 's/\.//')
	
	###for each coin, send appropriate color code to API for current price change
	
	###BTC
	###If BTC is 0 to 3.49%, send signal to set color green
	if [ $btc -ge 0 ] && [ $btc -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BTC +",
		"pid": "DK5QPID",
		"zoneId": "19,4",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BTC is +3.5 to 7.99%, send signal to blink color green
	elif [ $btc -ge 350 ] && [ $btc -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BTC +",
		"pid": "DK5QPID",
		"zoneId": "19,4",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BTC is >+8%, send signal to color cycle
	elif [ $btc -ge 800 ] && [ [ $btcstatus -ne 3 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BTC +",
		"pid": "DK5QPID",
		"zoneId": "19,4",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BTC is <0 to -3.49%, send signal to set color red
	elif [ $btc -lt 0 ] && [ $btc -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BTC -",
		"pid": "DK5QPID",
		"zoneId": "19,4",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BTC is <-3.5%, send signal to blink color red
	elif [ $btc -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BTC -",
		"pid": "DK5QPID",
		"zoneId": "19,4",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###ETH
	###If ETH is 0 to 3.49%, send signal to set color green
	if [ $eth -ge 0 ] && [ $eth -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ETH +",
		"pid": "DK5QPID",
		"zoneId": "20,4",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ETH is +3.5 to 7.99%, send signal to blink color green
	elif [ $eth -ge 350 ] && [ $eth -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ETH +",
		"pid": "DK5QPID",
		"zoneId": "20,4",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ETH is >+8%, send signal to color cycle
	elif [ $eth -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ETH +",
		"pid": "DK5QPID",
		"zoneId": "20,4",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ETH is <0 to -3.49%, send signal to set color red
	elif [ $eth -lt 0 ] && [ $eth -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ETH -",
		"pid": "DK5QPID",
		"zoneId": "20,4",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ETH is <-3.5%, send signal to blink color red
	elif [ $eth -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ETH -",
		"pid": "DK5QPID",
		"zoneId": "20,4",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###LTC
	###If LTC is 0 to 3.49%, send signal to set color green
	if [ $ltc -ge 0 ] && [ $ltc -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "LTC +",
		"pid": "DK5QPID",
		"zoneId": "21,4",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If LTC is +3.5 to 7.99%, send signal to blink color green
	elif [ $ltc -ge 350 ] && [ $ltc -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "LTC +",
		"pid": "DK5QPID",
		"zoneId": "21,4",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If LTC is >+8%, send signal to color cycle
	elif [ $ltc -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "LTC +",
		"pid": "DK5QPID",
		"zoneId": "21,4",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If LTC is <0 to -3.49%, send signal to set color red
	elif [ $ltc -lt 0 ] && [ $ltc -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "LTC -",
		"pid": "DK5QPID",
		"zoneId": "21,4",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If LTC is <-3.5%, send signal to blink color red
	elif [ $ltc -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "LTC -",
		"pid": "DK5QPID",
		"zoneId": "21,4",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###BCH
	###If BCH is 0 to 3.49%, send signal to set color green
	if [ $bch -ge 0 ] && [ $bch -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BCH +",
		"pid": "DK5QPID",
		"zoneId": "19,3",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BCH is +3.5 to 7.99%, send signal to blink color green
	elif [ $bch -ge 350 ] && [ $bch -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BCH +",
		"pid": "DK5QPID",
		"zoneId": "19,3",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BCH is >+8%, send signal to color cycle
	elif [ $bch -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BCH +",
		"pid": "DK5QPID",
		"zoneId": "19,3",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BCH is <0 to -3.49%, send signal to set color red
	elif [ $bch -lt 0 ] && [ $bch -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BCH -",
		"pid": "DK5QPID",
		"zoneId": "19,3",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BCH is <-3.5%, send signal to blink color red
	elif [ $bch -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BCH -",
		"pid": "DK5QPID",
		"zoneId": "19,3",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###XRP
	###If XRP is 0 to 3.49%, send signal to set color green
	if [ $xrp -ge 0 ] && [ $xrp -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XRP +",
		"pid": "DK5QPID",
		"zoneId": "20,3",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XRP is +3.5 to 7.99%, send signal to blink color green
	elif [ $xrp -ge 350 ] && [ $xrp -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XRP +",
		"pid": "DK5QPID",
		"zoneId": "20,3",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XRP is >+8%, send signal to color cycle
	elif [ $xrp -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XRP +",
		"pid": "DK5QPID",
		"zoneId": "20,3",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XRP is <0 to -3.49%, send signal to set color red
	elif [ $xrp -lt 0 ] && [ $xrp -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XRP -",
		"pid": "DK5QPID",
		"zoneId": "20,3",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XRP is <-3.5%, send signal to blink color red
	elif [ $xrp -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XRP -",
		"pid": "DK5QPID",
		"zoneId": "20,3",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###XMR
	###If XMR is 0 to 3.49%, send signal to set color green
	if [ $xmr -ge 0 ] && [ $xmr -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XMR +",
		"pid": "DK5QPID",
		"zoneId": "21,3",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XMR is +3.5 to 7.99%, send signal to blink color green
	elif [ $xmr -ge 350 ] && [ $xmr -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XMR +",
		"pid": "DK5QPID",
		"zoneId": "21,3",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XMR is >+8%, send signal to color cycle
	elif [ $xmr -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XMR +",
		"pid": "DK5QPID",
		"zoneId": "21,3",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XMR is <0 to -3.49%, send signal to set color red
	elif [ $xmr -lt 0 ] && [ $xmr -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XMR -",
		"pid": "DK5QPID",
		"zoneId": "21,3",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XMR is <-3.5%, send signal to blink color red
	elif [ $xmr -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XMR -",
		"pid": "DK5QPID",
		"zoneId": "21,3",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###ADA
	###If ADA is 0 to 3.49%, send signal to set color green
	if [ $ada -ge 0 ] && [ $ada -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ADA +",
		"pid": "DK5QPID",
		"zoneId": "19,2",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ADA is +3.5 to 7.99%, send signal to blink color green
	elif [ $ada -ge 350 ] && [ $ada -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ADA +",
		"pid": "DK5QPID",
		"zoneId": "19,2",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ADA is >+8%, send signal to color cycle
	elif [ $ada -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ADA +",
		"pid": "DK5QPID",
		"zoneId": "19,2",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ADA is <0 to -3.49%, send signal to set color red
	elif [ $ada -lt 0 ] && [ $ada -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ADA -",
		"pid": "DK5QPID",
		"zoneId": "19,2",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If ADA is <-3.5%, send signal to blink color red
	elif [ $ada -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "ADA -",
		"pid": "DK5QPID",
		"zoneId": "19,2",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###XLM
	###If XLM is 0 to 3.49%, send signal to set color green
	if [ $xlm -ge 0 ] && [ $xlm -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XLM +",
		"pid": "DK5QPID",
		"zoneId": "20,2",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XLM is +3.5 to 7.99%, send signal to blink color green
	elif [ $xlm -ge 350 ] && [ $xlm -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XLM +",
		"pid": "DK5QPID",
		"zoneId": "20,2",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XLM is >+8%, send signal to color cycle
	elif [ $xlm -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XLM +",
		"pid": "DK5QPID",
		"zoneId": "20,2",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XLM is <0 to -3.49%, send signal to set color red
	elif [ $xlm -lt 0 ] && [ $xlm -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XLM -",
		"pid": "DK5QPID",
		"zoneId": "20,2",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If XLM is <-3.5%, send signal to blink color red
	elif [ $xlm -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "XLM -",
		"pid": "DK5QPID",
		"zoneId": "20,2",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
	printf "\n"
	
	###BURST
	###If BURST is 0 to 3.49%, send signal to set color green
	if [ $burst -ge 0 ] && [ $burst -le 349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BURST +",
		"pid": "DK5QPID",
		"zoneId": "21,2",
		"effect": "SET_COLOR",
		"color": "#00FF00",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BURST is +3.5 to 7.99%, send signal to blink color green
	elif [ $burst -ge 350 ] && [ $burst -le 799 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BURST +",
		"pid": "DK5QPID",
		"zoneId": "21,2",
		"color": "#00FF00",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BURST is >+8%, send signal to color cycle
	elif [ $burst -ge 800 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BURST +",
		"pid": "DK5QPID",
		"zoneId": "21,2",
		"color": "#00FF00",
		"effect": "COLOR_CYCLE",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BURST is <0 to -3.49%, send signal to set color red
	elif [ $burst -lt 0 ] && [ $burst -ge -349 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BURST -",
		"pid": "DK5QPID",
		"zoneId": "21,2",
		"effect": "SET_COLOR",
		"color": "#FF0000",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	###If BURST is <-3.5%, send signal to blink color red
	elif [ $burst -le -350 ]; then
	curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $token" -X POST https://q.daskeyboard.com/api/1.0/signals -d '{
		"name": "BURST -",
		"pid": "DK5QPID",
		"zoneId": "21,2",
		"color": "#FF0000",
		"effect": "BLINK",
		"shouldNotify": false,
		"isArchived": false,
		"isRead": true,
		"isMuted": true}';
	fi
printf "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

##Waits 60 seconds before looping and starting over
sleep 60
done
