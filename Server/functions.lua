function isLogged(thePlayer) -- проверка на авторизацию
	return getElementData(thePlayer, "logged")
end
players = getElementsByType ( "player" )

function removeData(res)
	if res == resource then
		
		for theKey,thePlayer in ipairs(players) do -- use a generic for loop to step through each player
			setElementData(thePlayer,"skin",nil)
			--dbExec(getDbConnection(),"DELETE FROM `online` WHERE id='"..getElementData(thePlayer,"id").."'")
			setElementData(thePlayer, "nick", nil)
			setElementData(thePlayer, "logged", false)
			setElementData(thePlayer, "level", nil)
			setElementData(thePlayer, "exp", nil)
			setElementData(thePlayer, "alevel", nil )
			setElementData(thePlayer, "skin", nil )
			setElementData(thePlayer, "faction", nil )
			setElementData(thePlayer, "leader", nil)
			setElementData(thePlayer, "rank", nil )
			setElementData(thePlayer, "tableid", nil )
			setElementData(thePlayer, "walkstyle", nil )
			setElementPosition( thePlayer, 0, 0, 10000 )
			setElementFrozen(thePlayer,true)
		end
	end
end
addEventHandler("onResourceStop",root,removeData)

function getPlayerByNick( nick )
	for k, v in ipairs(getElementsByType("player")) do 
	    if getElementData(v,"nick") == nick then
	      	return v
	    end
    end 
end

function getAlevel( player )
	return getElementData( player, "alevel")
end

function getPlayer(player)
	local id = tonumber(player)
    if id ~= nil then
      	player = getPlayerByID( id )
    else
      	player = getPlayerByNick( player )
    end
	return player
end
