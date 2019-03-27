
function FactionSendMessage(player,msg,ooc)
	if getElementData(player,"faction") ~= 0 then
		local query = dbQuery(factionChatCallback,{player,msg,ooc},dbHandle,"SELECT nick FROM `online` WHERE fr_id='"..getElementData(player,"faction").."'")
	end
end

function factionChatCallback(qh,player,msg,ooc)
	local result = dbPoll(qh,0)
	if result then
		local rank = getElementData(player,"rank")
		local name = getElementData(player,"nick")
		local faction = getElementData(player,"faction")
		local playersend = {}
		for col,row in ipairs(result) do
			if ooc then
				triggerClientEvent(getPlayerByNick(row.nick),"outputChatMessage",player,"(( РАЦИЯ: "..name..": "..msg.." ))")
			else
				triggerClientEvent(getPlayerByNick(row.nick),"outputChatMessage",player,"РАЦИЯ: "..name..": "..msg)
			end
			
		end
	end
end

function FactionSetRankName(pl,rank,name)
	if getElementData(pl,"leader") == 1 then
		
	end
	outputDebugString("test")
end	

function FactionGetRankNames(res)
	if res == resource then
		local qh = dbQuery(parseFactionRanks,dbHandle,"SELECT * FROM `faction`")
	end
end
addEventHandler("onResourceStart",root,FactionGetRankNames)

function parseFactionRanks(qh)
	local result = dbPoll(qh,0)
	if result then
		for i,row in ipairs(result) do
			local id = row.id
			Faction_list[id] = {} -- для того, чтобы не жаловалось на след. строки
			Faction_list[id]["name"] = row.name
			Faction_list[id]["budget"] = row.budget
			Faction_list[id]["salary"] = row.salary
			Faction_list[id]["ranks"] = fromJSON(row.rank_names)
		end
	end
end

function getElementFaction(element)
	return getElementData(element,"faction") or false
end

function parseFactionCars(qh)
	local result = dbPoll(qh,0)
	if result then
		for i,row in ipairs(result) do
			veh = createVehicle(row.modelid,row.sx,row.sy,row.sz,row.rx,row.ry,row.rz,row.number)
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