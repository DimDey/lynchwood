walkstyles = { -- GLOBAL VARS
	[1] = 0,
	[2] = 118,
	[3] = 121,
	[4] = 129
}

walkstyles_anim = {
	[1] = "walk_player",
	[2] = "walk_civi",
	[3] = "walk_gang1",
	[4] = "woman_walknorm"
}
ids = {}
Faction_list = {}
carshops = {}
carshopmarkers = {}

addEventHandler("onPlayerWasted", root, -- когда игрок умер
	function()
		setTimer(spawnPlayer, 2000, 1, source, 391.658203125, -1524.560546875, 32.266296386719, 50, getElementData(source, "skin"))
	end
)

function getPlayers() -- передача игроков для таба
	triggerClientEvent("onReturnPlayers",source,ids,getMaxPlayers())
end
addEvent("onClientGetsPlayers",true)
addEventHandler("onClientGetsPlayers",root,getPlayers)

function onPlayerExitHandler()
	if getElementData(source,"pesc") then
		local x,y,z = getElementPosition(source)
		local players = getElementsWithinRange(x,y,z,10,"player")
		for i,player in ipairs(players) do
			if getElementFaction(player) == 1 then
				outputServerLog("JAILED: "..getElementData(source,"nick") or "NaN")
				break;
			end
		end
	end
	dbExec(dbHandle,"DELETE FROM `online` WHERE id='"..getElementData(source,"id").."'")
end
addEventHandler("onPlayerQuit",root,onPlayerExitHandler)

function removeNick() 
    setPlayerNametagShowing ( source, false ) 
end 
addEventHandler ("onPlayerJoin", root, removeNick) 