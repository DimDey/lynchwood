faction = {
	list = {},
	get = function(player) 
		if not(isElement(player)) then
			player = getPlayer(player)
		end
		local frid = getElementData(player,"frid")
		if frid then
			return faction.list[frid]
		end
	end,
	send = function(player,msg,ooc)
		if getElementData(player,"faction") ~= 0 then
			local query = dbQuery(faction.sendCallback,{player,msg,ooc},dbHandle,"SELECT nick FROM `online` WHERE fr_id='"..getElementData(player,"faction").."'")
		end
	end,
	sendCallback = function(qh,player,msg,ooc)
		local result = dbPoll(qh,0)
		if result then
			local rank = getElementData(player,"rank")
			local name = getElementData(player,"nick")
			local factionid = getElementData(player,"faction")
			local playersend = {}
			for col,row in ipairs(result) do
				if ooc then
					triggerClientEvent(getPlayerByNick(row.nick),"outputChatMessage",player,"(( РАЦИЯ: "..faction.list[factionid].ranks[rank].name.." "..name..": "..msg.." ))")
				else
					triggerClientEvent(getPlayerByNick(row.nick),"outputChatMessage",player,"РАЦИЯ: "..faction.list[factionid].ranks[rank].name.." "..name..": "..msg)
				end
				
			end
		end
	end,
	rank = {
		set = function(frid,id,prop,state)
			if prop == "name" then
				faction.list[frid].ranks[id].name = state
			elseif string.find(prop,"perm") then
				if prop == "perm_invite" then
					
				elseif prop == "perm_uninvite" then

				elseif prop == "perm_giverank" then

				end
			end
		end
	}
}


function FactionGetRankNames(res)
	if res == resource then
		local qh = dbQuery(parseFactionRanks,dbHandle,"SELECT * FROM `factions`")
	end
end
addEventHandler("onResourceStart",root,FactionGetRankNames)

function parseFactionRanks(qh)
	local result = dbPoll(qh,0)
	if result then
		for i,row in ipairs(result) do
			local id = row.id
			faction.list[id] = {} -- для того, чтобы не жаловалось на след. строки
			faction.list[id].name = row.name
			faction.list[id].budges = row.budget
			faction.list[id]["ranks"] = fromJSON(row.ranks)
		end
	end
end

function parseFactionCars(qh)
	local result = dbPoll(qh,0)
	if result then
		for i,row in ipairs(result) do
			veh = createVehicle(row.modelid,row.sx,row.sy,row.sz,row.rx,row.ry,row.rz,row.number)
			local vehCol = createColSphere(row.sx,row.sy,row.sz,2)
			attachElements(vehCol,veh)
			setVehicleColor(veh,row.r,row.g,row.b)
			setElementData(veh,"carid",row.carid)
			setElementData(veh,"frid",row.frid)
			setElementData(veh,"fuel",row.fuel)
			setElementData(veh,"broken",row.broken)
			setElementData(veh,"odometer",row.odometer)
		end
	end
end

function FactionUpdateCars()
	local qh = dbQuery(parseFactionCars,getDbConnection(),"SELECT * FROM `vehicles` WHERE frid")
end
addEventHandler("onResourceStart",resourceRoot,FactionUpdateCars)

function isHavePermission(player,perm)
	local pfr = getElementData(player,"frid")
	local prank = getElementData(player,"rank")
	if perm == "invite" then
		return faction.list[pfr].ranks[prank].invite
	elseif perm == "uninvite" then
		return faction.list[pfr].ranks[prank].uninvite
	else
		return faction.list[pfr].ranks[prank].giverank				
	end
end