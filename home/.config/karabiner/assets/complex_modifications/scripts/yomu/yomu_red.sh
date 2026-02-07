currentPosition=$(/opt/homebrew/bin/cliclick p)
/opt/homebrew/bin/cliclick c:.
yPosition=$(echo $currentPosition | cut -d "," -f 2)

if [ $yPosition -gt 993 ]
then
	/opt/homebrew/bin/cliclick -w 200 m:+15,1006 c:.
else
	/opt/homebrew/bin/cliclick -w 200 m:+15,+15 c:.
fi

sleep 0.5
/opt/homebrew/bin/cliclick c:.
sleep 0.1
/opt/homebrew/bin/cliclick -w 100 m:$currentPosition