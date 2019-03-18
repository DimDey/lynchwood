local tabRenderTarget = dxCreateRenderTarget( screenW, screenH, true )
local maxplayers = 500
players = {}

--[[503, 227, 16, 21]]

function dxDrawTabList()
	if isLogged(lp) then
		if ( getKeyState( "TAB" ) ) then
			local x,y,z = getElementPosition(lp)
			ypos = screenH * (198/sY)
			count = 0
			dxDrawImage((screenW - 582) / 2, (screenH - 607) / 2, 582, 607, "Images/tablist/tabmask.png")
			dxDrawText(getZoneName(x,y,z), screenW * (519/sX), screenH * (160/sY), 659, 182, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center")
			for i,player in pairs(players) do
				local id = tostring(getElementData(player,"id"))
					dxDrawText(id, screenW * (509/sX), ypos, 528, 223, tocolor(255, 255, 255, 255), 1.00, "default", "left", "center")
				if getElementData(player,"logged") then
					dxDrawText(getElementData(player,"nick"), screenW * (669/sX), ypos, 761, 223, tocolor(255, 255, 255, 255), 1.00, "default", "left", "center", false, false, true, false, false)
				else	
					dxDrawText("Не авторизован(-а)", screenW * (500/sX), ypos, 990, 297, tocolor(255, 255, 255, 255), 1.00, "default", "left", "center")
				end
				dxDrawText(getPlayerPing(player), screenW * (859/sX), ypos, 951, 227, tocolor(255, 255, 255, 255), 1.00, "default", "right", "center")	
				count = count + 1
				ypos = ypos + 37
			end
			dxDrawText(count.."/"..maxplayers, screenW * (892/sX), screenH * (158/sY), 951, 182, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center")
		end
	end
end
addEventHandler("onClientRender",root,dxDrawTabList)

function updatePlayers()
	triggerServerEvent("onClientGetsPlayers",lp)
end
addEventHandler("onClientPlayerJoin",root,updatePlayers)
addEventHandler("onClientResourceStart",resourceRoot,updatePlayers)

function onReturnsPlayers(ids,max)
	players = ids
	maxplayers = maxplayers
end
addEvent("onReturnPlayers",true)
addEventHandler("onReturnPlayers",root,onReturnsPlayers)

addEventHandler( "onClientPlayerQuit", root, function( )
	--scrollCache = math.min( scrollCache, getPlayerCount() * r_height ) 
	updatePlayers()
end)