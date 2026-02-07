currentPosition=$(/opt/homebrew/bin/cliclick p)
/opt/homebrew/bin/cliclick c:.
yPosition=$(echo $currentPosition | cut -d "," -f 2)

if [ $yPosition -gt 993 ]
then
	/opt/homebrew/bin/cliclick -w 200 m:+15,1030 c:.
else
	/opt/homebrew/bin/cliclick -w 200 m:+15,+30 c:.
fi

sleep 0.5
/opt/homebrew/bin/cliclick m:+0,-25 c:.
sleep 0.1
/opt/homebrew/bin/cliclick m:$currentPosition