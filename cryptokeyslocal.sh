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
##                          7 key = Loki                                                  ##
##                          8 key = Stellar Lumens                                        ##
##                          9 key = Burst                                                 ##
##                                                                                        ##
############################################################################################
############################################################################################

##Initially defines key color status variables
onestat=0
twostat=0
threestat=0
fourstat=0
fivestat=0
eightstat=0
sevenstat=0
sixstat=0
ninestat=0

##Sets infinite loop (CTRL+C to stop)
while :
do

		###Define public API URL
		PORT=27301
		URL="http://localhost:$PORT/api/1.0/signals"
		
##Define coinmarketcap API coin identifier integers. For each coin, coinmarketcap assigns an integer for API calls, this must be defined here.		

		ONE=1
		TWO=1027
		THREE=2
		FOUR=1831
		FIVE=52
		SIX=512
		SEVEN=2748
		EIGHT=328
		NINE=573
		
  ###Define 24h change value variables, create hundredth decimal place and remove decimal to create integer
  
        one=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$ONE/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        two=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$TWO/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        three=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$THREE/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        four=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$FOUR/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        five=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$FIVE/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        eight=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$SIX/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        seven=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$SEVEN/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        six=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$EIGHT/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')
        nine=$(curl -s -X GET "https://api.coinmarketcap.com/v2/ticker/$NINE/?structure=array" | grep change_24h | cut -d: -f2 | sed -e 's/ //g' -e 's/,//' | bc -l | xargs printf "%.2f" | sed 's/\.//')

        ###for each coin, send appropriate color code to API for current price change

        ###ONE
        ###If ONE is 0 to 3.49%, send signal to set color green
        if [ "$one" -ge 0 ] && [ "$one" -le 349 ] && [ "$onestat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ONE +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( onestat=1 ));
        ###If ONE is +3.5 to 7.99%, send signal to blink color green
        elif [ "$one" -ge 350 ] && [ "$one" -le 799 ] && [ "$onestat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ONE +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( onestat=2 ));
        ###If ONE is >+8%, send signal to color cycle
        elif [ "$one" -ge 800 ] && [ "$onestat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ONE +",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( onestat=3 ));
        ###If ONE is <0 to -3.49%, send signal to set color red
        elif [ "$one" -lt 0 ] && [ "$one" -ge -349 ] && [ "$onestat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ONE -",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( onestat=4 ));
        ###If ONE is <-3.5%, send signal to blink color red
        elif [ "$one" -le -350 ] && [ "$onestat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "ONE -",
                "pid": "DK5QPID",
                "zoneId": "19,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( onestat=5 ));
        fi
        

        ###TWO
        ###If TWO is 0 to 3.49%, send signal to set color green
        if [ "$two" -ge 0 ] && [ "$two" -le 349 ] && [ "$twostat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "TWO +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( twostat=1 ));
        ###If TWO is +3.5 to 7.99%, send signal to blink color green
        elif [ "$two" -ge 350 ] && [ "$two" -le 799 ] && [ "$twostat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "TWO +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( twostat=2 ));
        ###If TWO is >+8%, send signal to color cycle
        elif [ "$two" -ge 800 ] && [ "$twostat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "TWO +",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( twostat=3 ));
        ###If TWO is <0 to -3.49%, send signal to set color red
        elif [ "$two" -lt 0 ] && [ "$two" -ge -349 ] && [ "$twostat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "TWO -",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( twostat=4 ));
        ###If TWO is <-3.5%, send signal to blink color red
        elif [ "$two" -le -350 ] && [ "$twostat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "TWO -",
                "pid": "DK5QPID",
                "zoneId": "20,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( twostat=5 ));
        fi
        

        ###THREE
        ###If THREE is 0 to 3.49%, send signal to set color green
        if [ "$three" -ge 0 ] && [ "$three" -le 349 ] && [ "$threestat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "THREE +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( threestat=1 ));
        ###If THREE is +3.5 to 7.99%, send signal to blink color green
        elif [ "$three" -ge 350 ] && [ "$three" -le 799 ] && [ "$threestat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "THREE +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( threestat=2 ));
        ###If THREE is >+8%, send signal to color cycle
        elif [ "$three" -ge 800 ] && [ "$threestat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "THREE +",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( threestat=3 ));
        ###If THREE is <0 to -3.49%, send signal to set color red
        elif [ "$three" -lt 0 ] && [ "$three" -ge -349 ] && [ "$threestat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "THREE -",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( threestat=4 ));
        ###If THREE is <-3.5%, send signal to blink color red
        elif [ "$three" -le -350 ] && [ "$threestat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "THREE -",
                "pid": "DK5QPID",
                "zoneId": "21,4",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( threestat=5 ));
        fi
        

        ##FOUR
        ###If FOUR is 0 to 3.49%, send signal to set color green
        if [ "$four" -ge 0 ] && [ "$four" -le 349 ] && [ "$fourstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FOUR +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fourstat=1 ));
        ###If FOUR is +3.5 to 7.99%, send signal to blink color green
        elif [ "$four" -ge 350 ] && [ "$four" -le 799 ] && [ "$fourstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FOUR +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fourstat=2 ));
        ###If FOUR is >+8%, send signal to color cycle
        elif [ "$four" -ge 800 ] && [ "$fourstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FOUR +",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fourstat=3 ));
        ###If FOUR is <0 to -3.49%, send signal to set color red
        elif [ "$four" -lt 0 ] && [ "$four" -ge -349 ] && [ "$fourstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FOUR -",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fourstat=4 ));
        ###If FOUR is <-3.5%, send signal to blink color red
        elif [ "$four" -le -350 ] && [ "$fourstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FOUR -",
                "pid": "DK5QPID",
                "zoneId": "19,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fourstat=5 ));
        fi
        

        ###FIVE
        ###If FIVE is 0 to 3.49%, send signal to set color green
        if [ "$five" -ge 0 ] && [ "$five" -le 349 ] && [ "$fivestat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FIVE +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fivestat=1 ));
        ###If FIVE is +3.5 to 7.99%, send signal to blink color green
        elif [ "$five" -ge 350 ] && [ "$five" -le 799 ] && [ "$fivestat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FIVE +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fivestat=2 ));
        ###If FIVE is >+8%, send signal to color cycle
        elif [ "$five" -ge 800 ] && [ "$fivestat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FIVE +",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fivestat=3 ));
        ###If FIVE is <0 to -3.49%, send signal to set color red
        elif [ "$five" -lt 0 ] && [ "$five" -ge -349 ] && [ "$fivestat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FIVE -",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fivestat=4 ));
        ###If FIVE is <-3.5%, send signal to blink color red
        elif [ "$five" -le -350 ] && [ "$fivestat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "FIVE -",
                "pid": "DK5QPID",
                "zoneId": "20,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( fivestat=5 ));
        fi
        

        ###EIGHT
        ###If EIGHT is 0 to 3.49%, send signal to set color green
        if [ "$six" -ge 0 ] && [ "$six" -le 349 ] && [ "$sixstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "EIGHT +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sixstat=1 ));
        ###If EIGHT is +3.5 to 7.99%, send signal to blink color green
        elif [ "$six" -ge 350 ] && [ "$six" -le 799 ] && [ "$sixstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "EIGHT +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sixstat=2 ));
        ###If EIGHT is >+8%, send signal to color cycle
        elif [ "$six" -ge 800 ] && [ "$sixstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "EIGHT +",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sixstat=3 ));
        ###If EIGHT is <0 to -3.49%, send signal to set color red
        elif [ "$six" -lt 0 ] && [ "$six" -ge -349 ] && [ "$sixstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "EIGHT -",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sixstat=4 ));
        ###If EIGHT is <-3.5%, send signal to blink color red
        elif [ "$six" -le -350 ] && [ "$sixstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "EIGHT -",
                "pid": "DK5QPID",
                "zoneId": "21,3",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sixstat=5 ));
        fi
        

        ###SEVEN
        ###If SEVEN is 0 to 3.49%, send signal to set color green
        if [ "$seven" -ge 0 ] && [ "$seven" -le 349 ] && [ "$sevenstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SEVEN +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sevenstat=1 ));
        ###If SEVEN is +3.5 to 7.99%, send signal to blink color green
        elif [ "$seven" -ge 350 ] && [ "$seven" -le 799 ] && [ "$sevenstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SEVEN +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sevenstat=2 ));
        ###If SEVEN is >+8%, send signal to color cycle
        elif [ "$seven" -ge 800 ] && [ "$sevenstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SEVEN +",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sevenstat=3 ));
        ###If SEVEN is <0 to -3.49%, send signal to set color red
        elif [ "$seven" -lt 0 ] && [ "$seven" -ge -349 ] && [ "$sevenstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SEVEN -",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sevenstat=4 ));
        ###If SEVEN is <-3.5%, send signal to blink color red
        elif [ "$seven" -le -350 ] && [ "$sevenstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SEVEN -",
                "pid": "DK5QPID",
                "zoneId": "19,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( sevenstat=5 ));
        fi
        

        ###SIX
        ###If SIX is 0 to 3.49%, send signal to set color green
        if [ "$eight" -ge 0 ] && [ "$eight" -le 349 ] && [ "$eightstat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SIX +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( eightstat=1 ));
        ###If SIX is +3.5 to 7.99%, send signal to blink color green
        elif [ "$eight" -ge 350 ] && [ "$eight" -le 799 ] && [ "$eightstat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SIX +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( eightstat=2 ));
        ###If SIX is >+8%, send signal to color cycle
        elif [ "$eight" -ge 800 ] && [ "$eightstat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SIX +",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( eightstat=3 ));
        ###If SIX is <0 to -3.49%, send signal to set color red
        elif [ "$eight" -lt 0 ] && [ "$eight" -ge -349 ] && [ "$eightstat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SIX -",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( eightstat=4 ));
        ###If SIX is <-3.5%, send signal to blink color red
        elif [ "$eight" -le -350 ] && [ "$eightstat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "SIX -",
                "pid": "DK5QPID",
                "zoneId": "20,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( eightstat=5 ));
        fi
        

        ###NINE
        ###If NINE is 0 to 3.49%, send signal to set color green
        if [ "$nine" -ge 0 ] && [ "$nine" -le 349 ] && [ "$ninestat" -ne 1 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "NINE +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "effect": "SET_COLOR",
                "color": "#00FF00",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ninestat=1 ));
        ###If NINE is +3.5 to 7.99%, send signal to blink color green
        elif [ "$nine" -ge 350 ] && [ "$nine" -le 799 ] && [ "$ninestat" -ne 2 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "NINE +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#00FF00",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ninestat=2 ));
        ###If NINE is >+8%, send signal to color cycle
        elif [ "$nine" -ge 800 ] && [ "$ninestat" -ne 3 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "NINE +",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#00FF00",
                "effect": "COLOR_CYCLE",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ninestat=3 ));
        ###If NINE is <0 to -3.49%, send signal to set color red
        elif [ "$nine" -lt 0 ] && [ "$nine" -ge -349 ] && [ "$ninestat" -ne 4 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "NINE -",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "effect": "SET_COLOR",
                "color": "#FF0000",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ninestat=4 ));
        ###If NINE is <-3.5%, send signal to blink color red
        elif [ "$nine" -le -350 ] && [ "$ninestat" -ne 5 ]; then
        curl -X POST $URL --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
                "name": "NINE -",
                "pid": "DK5QPID",
                "zoneId": "21,2",
                "color": "#FF0000",
                "effect": "BLINK",
                "shouldNotify": false,
                "isArchived": false,
                "isRead": true,
                "isMuted": true
				}' &> /dev/null && (( ninestat=5 ));
        fi

##Waits 10 seconds before looping and starting over
sleep 10

done
