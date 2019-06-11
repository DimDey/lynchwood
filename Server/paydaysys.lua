payday = {
	started = false,
	inital = function()
		local time = getRealTime()
		local hours = time.hour
		local minutes = time.minute
		local seconds = time.second
		if time.minute == 0 then
			if not(payday.started) then
				payday.started = true
				for i,player in ipairs(players) do
					triggerClientEvent(player,"outputChatMessage",player,"(( PAYDAY ))")
					setPlayerMoney(player,getPlayerMoney(player)+1000)
				end
				payday.started = false
			end
		end
	end
}
setTimer(payday.inital,60000,0)