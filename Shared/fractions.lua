Faction_spawn = {
	[1] = {Vector3(391.658203125,-1524.560546875,52.266296386719),0},
	[2] = {Vector3(0,0,0),0}
}

function FactionInvite(player,target)
	if target ~= player then
		if getElementData(player,"leader") ~= 0 then
			if getElementData(player,"rank_caninvite") then
				if getElementData(target,"faction") == 0 then
					triggerClientEvent("outputChatMessage",target,"Вас пригласили во фракцию"..Faction_list[getElementData(player,"faction")])
					triggerClientEvent("outputChatMessage",player,"Вы пригласили "..getElementData(target,"nick").." в фракцию.")
				else
					triggerClientEvent("outputChatMessage",player,"Игрок уже где-то состоит")
				end
			end
		else
			triggerClientEvent("outputChatMessage",player,"Игрок является лидером.")
		end
	else
		triggerClientEvent("outputChatMessage",player,"Вы не можете пригласить себя.")
	end
end

function FactionUnInvite(player,target,reason)
	if target ~= player then
		if getElementData(target,"faction") == getElementData(player,"faction") then
			if getElementData(player,"rank_canuninvite") then

			else
				triggerClientEvent(player,"outputChatMessage","Недостаточно прав.")
			end
		end
	else
		triggerClientEvent("outputChatMessage",player,"Вы не можете уволить себя.")
	end
end

function FactionChangeRankSettings(faction,rank,player)

end