
function FactionSendMessage(player,msg)
	if getElementData(player,"faction") ~= 0 then
		local query = dbQuery(factionChatCallback,{player,msg},dbHandle,"SELECT id FROM `online` WHERE fr_id='"..getElementData(player,"faction").."'")
	end
end

function factionChatCallback(qh,player,msg)
	local result = dbPoll(qh,0)
	if result then
		local rank = getElementData(player,"rank")
		local name = getElementData(player,"nick")
		local faction = getElementData(player,"faction")
		local rankname = Faction_list[faction]["ranks"][tostring(rank)]
		local playersend = {}
		for col,row in ipairs(result) do
			playersend[#playersend+1] = ids[row.id]
		end
		triggerClientEvent(playersend,"outputChatMessage",player,rankname.." "..name..": "..msg)
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

function FactionUpdateRank()
	if frid ~= 0 then
		local qh = dbQuery(parseFactionRank,{frid},dbHandle,"SELECT `rank_names` FROM `faction` WHERE id='"..frid.."'")
	end
end

function parseFactionRank(qh,frid)
	local result = dbPoll(qh,0)
	if result then
		for col,row in ipairs(result) do
			Faction_list[frid]["ranks"] = fromJSON(row.rank_names)
		end
	end
end

function getElementFaction(element)
	return getElementData(element,"faction") or false
end