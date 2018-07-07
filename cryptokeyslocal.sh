#!/bin/bash

############################################################################################
############################################################################################
##                                                                                        ##
## This script changes the colors of the numpad keys according to the 24 hour change      ##
## price of various cryptocurrencies. The price change is pulled from coinmarketcap.com's ##
## API and the correct color and effect is sent to the keyboard API                       ##
##                                                                                        ##
##                          +0-3.49% - Set color green                                    ##
##                          +3.5-7.99% - Blink green                                      ##
##                          +8+% - Color cycle                                            ##
##                          -.1-3.49% - Set color red                                     ##
##                          -3.5-% - Blink red                                            ##
##                                                                                        ##
##                          1 key = Bitcoin                                               ##
##                          2 key = Ethereum                                              ##
##                          3 key = Litecoin                                              ##
##                          4 key = BitcoinCash                                           ##
##                          5 key = Ripple                                                ##
##                          6 key = Monero                                                ##
##                          7 key = Cardano                                               ##
##                          8 key = Stellar Lumens                                        ##
##                          9 key = Burst                                                 ##
##                                                                                        ##
############################################################################################
############################################################################################

##Initially defines key color status variables
btcstat=0
ethstat=0
ltcstat=0
bchstat=0
xrpstat=0
xlmstat=0
adastat=0
xmrstat=0
burststat=0

##Sets infinite loop (CTRL+C to stop)
while :
do

		###Define public API URL
		PORT=27301
		URL="http://localhost:$PORT/api/1.0/signals"
		
        ###Define 24h change value variables, create hundredth decimal place and remove decimal to create integer

		BTC=1
		ETH=1027
		LTC=2
		BCH=1831
		XRP=52
		XLM=512
		ADA=2010
		XMR=328
		BURST=573
		
        btc=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$BTC/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        eth=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$ETH/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        ltc=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$LTC/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        bch=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$BCH/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        xrp=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$XRP/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        xlm=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$XLM/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        ada=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$ADA/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        xmr=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$XMR/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        burst=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$BURST/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')

        ###for each coin, send appropriate color code to API for current price change

        ###BTC
        ###If BTC is 0 to 3.49%, send signal to set color green
        if [ "$btc" -ge 0 ] && [ "$btc" -le 349 ] && [ "$btcstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BTC +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( btcstat=1 ));
        ###If BTC is +3.5 to 7.99%, send signal to blink color green
        elif [ "$btc" -ge 350 ] && [ "$btc" -le 799 ] && [ "$btcstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BTC +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( btcstat=2 ));
        ###If BTC is >+8%, send signal to color cycle
        elif [ "$btc" -ge 800 ] && [ "$btcstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BTC +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( btcstat=3 ));
        ###If BTC is <0 to -3.49%, send signal to set color red
        elif [ "$btc" -lt 0 ] && [ "$btc" -ge -349 ] && [ "$btcstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BTC -",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( btcstat=4 ));
        ###If BTC is <-3.5%, send signal to blink color red
        elif [ "$btc" -le -350 ] && [ "$btcstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BTC -",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( btcstat=5 ));
        fi
        

        ###ETH
        ###If ETH is 0 to 3.49%, send signal to set color green
        if [ "$eth" -ge 0 ] && [ "$eth" -le 349 ] && [ "$ethstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ETH +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ethstat=1 ));
        ###If ETH is +3.5 to 7.99%, send signal to blink color green
        elif [ "$eth" -ge 350 ] && [ "$eth" -le 799 ] && [ "$ethstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ETH +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ethstat=2 ));
        ###If ETH is >+8%, send signal to color cycle
        elif [ "$eth" -ge 800 ] && [ "$ethstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ETH +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ethstat=3 ));
        ###If ETH is <0 to -3.49%, send signal to set color red
        elif [ "$eth" -lt 0 ] && [ "$eth" -ge -349 ] && [ "$ethstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ETH -",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ethstat=4 ));
        ###If ETH is <-3.5%, send signal to blink color red
        elif [ "$eth" -le -350 ] && [ "$ethstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ETH -",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ethstat=5 ));
        fi
        

        ###LTC
        ###If LTC is 0 to 3.49%, send signal to set color green
        if [ "$ltc" -ge 0 ] && [ "$ltc" -le 349 ] && [ "$ltcstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "LTC +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ltcstat=1 ));
        ###If LTC is +3.5 to 7.99%, send signal to blink color green
        elif [ "$ltc" -ge 350 ] && [ "$ltc" -le 799 ] && [ "$ltcstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "LTC +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ltcstat=2 ));
        ###If LTC is >+8%, send signal to color cycle
        elif [ "$ltc" -ge 800 ] && [ "$ltcstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "LTC +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ltcstat=3 ));
        ###If LTC is <0 to -3.49%, send signal to set color red
        elif [ "$ltc" -lt 0 ] && [ "$ltc" -ge -349 ] && [ "$ltcstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "LTC -",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ltcstat=4 ));
        ###If LTC is <-3.5%, send signal to blink color red
        elif [ "$ltc" -le -350 ] && [ "$ltcstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "LTC -",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ltcstat=5 ));
        fi
        

        ##BCH
        ###If BCH is 0 to 3.49%, send signal to set color green
        if [ "$bch" -ge 0 ] && [ "$bch" -le 349 ] && [ "$bchstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BCH +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( bchstat=1 ));
        ###If BCH is +3.5 to 7.99%, send signal to blink color green
        elif [ "$bch" -ge 350 ] && [ "$bch" -le 799 ] && [ "$bchstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BCH +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( bchstat=2 ));
        ###If BCH is >+8%, send signal to color cycle
        elif [ "$bch" -ge 800 ] && [ "$bchstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BCH +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( bchstat=3 ));
        ###If BCH is <0 to -3.49%, send signal to set color red
        elif [ "$bch" -lt 0 ] && [ "$bch" -ge -349 ] && [ "$bchstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BCH -",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( bchstat=4 ));
        ###If BCH is <-3.5%, send signal to blink color red
        elif [ "$bch" -le -350 ] && [ "$bchstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BCH -",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( bchstat=5 ));
        fi
        

        ###XRP
        ###If XRP is 0 to 3.49%, send signal to set color green
        if [ "$xrp" -ge 0 ] && [ "$xrp" -le 349 ] && [ "$xrpstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XRP +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xrpstat=1 ));
        ###If XRP is +3.5 to 7.99%, send signal to blink color green
        elif [ "$xrp" -ge 350 ] && [ "$xrp" -le 799 ] && [ "$xrpstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XRP +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xrpstat=2 ));
        ###If XRP is >+8%, send signal to color cycle
        elif [ "$xrp" -ge 800 ] && [ "$xrpstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XRP +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xrpstat=3 ));
        ###If XRP is <0 to -3.49%, send signal to set color red
        elif [ "$xrp" -lt 0 ] && [ "$xrp" -ge -349 ] && [ "$xrpstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XRP -",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xrpstat=4 ));
        ###If XRP is <-3.5%, send signal to blink color red
        elif [ "$xrp" -le -350 ] && [ "$xrpstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XRP -",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xrpstat=5 ));
        fi
        

        ###XMR
        ###If XMR is 0 to 3.49%, send signal to set color green
        if [ "$xmr" -ge 0 ] && [ "$xmr" -le 349 ] && [ "$xmrstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XMR +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xmrstat=1 ));
        ###If XMR is +3.5 to 7.99%, send signal to blink color green
        elif [ "$xmr" -ge 350 ] && [ "$xmr" -le 799 ] && [ "$xmrstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XMR +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xmrstat=2 ));
        ###If XMR is >+8%, send signal to color cycle
        elif [ "$xmr" -ge 800 ] && [ "$xmrstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XMR +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xmrstat=3 ));
        ###If XMR is <0 to -3.49%, send signal to set color red
        elif [ "$xmr" -lt 0 ] && [ "$xmr" -ge -349 ] && [ "$xmrstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XMR -",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xmrstat=4 ));
        ###If XMR is <-3.5%, send signal to blink color red
        elif [ "$xmr" -le -350 ] && [ "$xmrstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XMR -",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xmrstat=5 ));
        fi
        

        ###ADA
        ###If ADA is 0 to 3.49%, send signal to set color green
        if [ "$ada" -ge 0 ] && [ "$ada" -le 349 ] && [ "$adastat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ADA +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( adastat=1 ));
        ###If ADA is +3.5 to 7.99%, send signal to blink color green
        elif [ "$ada" -ge 350 ] && [ "$ada" -le 799 ] && [ "$adastat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ADA +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( adastat=2 ));
        ###If ADA is >+8%, send signal to color cycle
        elif [ "$ada" -ge 800 ] && [ "$adastat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ADA +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( adastat=3 ));
        ###If ADA is <0 to -3.49%, send signal to set color red
        elif [ "$ada" -lt 0 ] && [ "$ada" -ge -349 ] && [ "$adastat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ADA -",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( adastat=4 ));
        ###If ADA is <-3.5%, send signal to blink color red
        elif [ "$ada" -le -350 ] && [ "$adastat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ADA -",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( adastat=5 ));
        fi
        

        ###XLM
        ###If XLM is 0 to 3.49%, send signal to set color green
        if [ "$xlm" -ge 0 ] && [ "$xlm" -le 349 ] && [ "$xlmstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XLM +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xlmstat=1 ));
        ###If XLM is +3.5 to 7.99%, send signal to blink color green
        elif [ "$xlm" -ge 350 ] && [ "$xlm" -le 799 ] && [ "$xlmstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XLM +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xlmstat=2 ));
        ###If XLM is >+8%, send signal to color cycle
        elif [ "$xlm" -ge 800 ] && [ "$xlmstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XLM +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xlmstat=3 ));
        ###If XLM is <0 to -3.49%, send signal to set color red
        elif [ "$xlm" -lt 0 ] && [ "$xlm" -ge -349 ] && [ "$xlmstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XLM -",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xlmstat=4 ));
        ###If XLM is <-3.5%, send signal to blink color red
        elif [ "$xlm" -le -350 ] && [ "$xlmstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "XLM -",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( xlmstat=5 ));
        fi
        

        ###BURST
        ###If BURST is 0 to 3.49%, send signal to set color green
        if [ "$burst" -ge 0 ] && [ "$burst" -le 349 ] && [ "$burststat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BURST +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( burststat=1 ));
        ###If BURST is +3.5 to 7.99%, send signal to blink color green
        elif [ "$burst" -ge 350 ] && [ "$burst" -le 799 ] && [ "$burststat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BURST +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( burststat=2 ));
        ###If BURST is >+8%, send signal to color cycle
        elif [ "$burst" -ge 800 ] && [ "$burststat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BURST +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( burststat=3 ));
        ###If BURST is <0 to -3.49%, send signal to set color red
        elif [ "$burst" -lt 0 ] && [ "$burst" -ge -349 ] && [ "$burststat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BURST -",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( burststat=4 ));
        ###If BURST is <-3.5%, send signal to blink color red
        elif [ "$burst" -le -350 ] && [ "$burststat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "BURST -",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( burststat=5 ));
        fi

##Waits 10 seconds before looping and starting over
sleep 10

done
