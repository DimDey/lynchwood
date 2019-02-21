function checkTime( )
	local timer = getRealTime()
	seconds = timer.second
	if minutes == 0 then
		onPayDay()
	end
end
setTimer( checkTime, 1000, 0 )

function onPayDay( )
	local players = getElementsByType ( "player" ) -- get a table of all the players in the server
	for k,v in ipairs(ids) do
		if isLogged(v) then
			triggerClientEvent("outputChatMessage",v,"PAYDAY")
		end
	end
end
addEvent("onPayDay",true)
addEventHandler("onPayDay",root,onPayDay)