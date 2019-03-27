function onCommand(cmd)
	local func = "cmd_" .. cmd[1]
	if _G[func] then
		table.remove(cmd,1)
		assert(loadstring(func .. "(...)"))(cmd)
	else
		triggerClientEvent(source, "outputChatMessage", source, "Команда не найдена.", "#990000")
	end
end

addEvent("sendCommand", true)
addEventHandler("sendCommand",root, onCommand)


function cmd_a(args)
	if getElementData(source,"alevel") > 0 then
		local qh = dbQuery(function(qh,sourcePlayer,args)
			local result = dbPoll(qh,0)
			if result then
				for k,row in ipairs(result) do
					if row.alevel > 0 then
						triggerClientEvent( {getPlayer(row.nick)}, "outputAdminChatMessage", sourcePlayer, getElementData(sourcePlayer,"nick")..": ", args )
					end
				end
			end
		end,{source,args},dbHandle,"SELECT `alevel`,`id` FROM `online`")
	end
end

function doAchat(qh,source,args)
	local result = dbPoll( qh, -1 )
	if result then
		for _,row in ipairs(result) do
			if getElementData( source, "nick") == row["nick"] then
				
			end
		end
	end
end

function cmd_admins( args )
	triggerClientEvent( source,"outputChatMessage", source, "Администраторы в сети:")
	for k,v in pairs(table_admins) do
		triggerClientEvent( source,"outputChatMessage", source, getElementData( v, "nick").."( "..getElementData( v, "alevel").. " )")
	end
end

function cmd_me(args)
	local msg = ""
	for i, theMsg in pairs(args) do
		msg = msg.." "..theMsg
	end
	if args[1] == nil then
		triggerClientEvent(source, "outputChatMessage", source, "Используйте /me [действие]", "#990000")
	else
		sendMessageToAll(source,15,"#D667FF",getElementData(source,"nick").."["..getElementData(source,"id").."]: "..msg)
	end
end

function cmd_do(args)
	text = ""
	for i, theMsg in pairs(args) do
		text = text.." "..theMsg
	end
	text = removeHex(text)
	if string.len(text) > 0 then
		local lpName = getElementData(source,"nick")
		sendMessageToAll(source,15,"#D667FF",text.. " (( "..lpName.." ))")
	else
		triggerClientEvent(source,"outputChatMessage",source,"Используйте: /do [Текст]", "#A9A9A9")
	end
end

function cmd_todo(args)
	local msg = ""
	for i, theMsg in pairs(args) do
		msg = msg.." "..theMsg
	end
	local first = split(msg,"*")
	if first[2] ~= nil then
		local second = string.gsub(msg,unpack(first).."%*","")
		if string.len(string.gsub(unpack(first),"%s+","")) > 0 and string.len(string.gsub(second,"%s+","")) > 0 then
			sendMessageToAll(source,15,"#FFFFFF",unpack(first)..", - сказал "..getElementData(source,"nick")..", #D667FF"..second)
		end
	end
end

function cmd_s( args )
	local msg = ""
	for i, theMsg in pairs(args) do
		msg = msg.." "..theMsg
	end
	if string.len(removeHex(msg)) > 0 and string.len(string.gsub(msg,"%*","")) > 0 then
		sendMessageToAll(source,20,nil,getElementData(source,"nick").."["..getElementData(source,"id").."] крикнул: "..msg)
	end
end

function cmd_w( args )
	local msg = ""
	for i, theMsg in pairs(args) do
		msg = msg.." "..theMsg
	end
	if string.len(removeHex(msg)) > 0 and string.len(string.gsub(msg,"%*","")) > 0 then
		sendMessageToAll(source,10,nil,getElementData(source,"nick").."["..getElementData(source,"id").."] шепчет: "..msg)
	end
end

function cmd_makeleader(args)
	player = args[1]
	player_leader = false
	fr_id = tonumber(args[2])
	player_id = tonumber(args[1])
	if type(player_id) == "number" then
		player = getPlayerByID(player_id)
		player_nick = getElementData( player, "nick")
	else
		player_nick = player
		player = getPlayerByNick(player_nick)
	end 
	setPlayerLeader(player,fr_id)
	if fr_id > 0 then
		triggerClientEvent( source,"outputChatMessage", source, "Вы назначили "..player_nick.." на пост лидера "..Fraction_list[fr_id])
		triggerClientEvent( player,"outputChatMessage", player, "Вы были назначены на пост лидера "..Fraction_list[fr_id])
		player_leader = true
	else
		triggerClientEvent( source,"outputChatMessage", source, "Вы сняли с поста лидера игрока "..player_nick)
		triggerClientEvent( player,"outputChatMessage", player, "Вы были сняты с поста лидера")
	end
	dbExec(dbHandle,"UPDATE `accounts` SET `fraction` = ?, `leader` = '?' WHERE `accounts`.`nick` = ?", fr_id,player_leader,player_nick)
end

function cmd_checkleader()
	local frac_id = getElementData(source,"leader")
	if frac_id == nil or frac_id == false then 
		triggerClientEvent( source, "outputChatMessage", source, "Вы не лидер")
	elseif frac_id >= 1 then
		triggerClientEvent( source, "outputChatMessage", source, "Вы лидер "..Faction_list[frac_id])
	end
end

function cmd_pc()
	triggerClientEvent( source, "createPopUp", source,"TEST",5)
end

function cmd_setwalk(args)
	if args[1] ~= nil then
		local style = tonumber(args[1])
		if style <= #walkstyles then
			local walkstyle = walkstyles[style]
			dbExec(dbHandle,"UPDATE `accounts` SET `walkstyle` = ? WHERE `accounts`.`nick` = ?", style, getElementData(source,"nick"))
			setPedWalkingStyle( source, walkstyles[style] )
			setElementData( source, "walkstyle",style )
			triggerClientEvent( source, "outputChatMessage", source, "Вы сменили свою походку!")
		end
	end
end

function cmd_walk( )
	walkstyle = walkstyles_anim[getElementData(source,"walkstyle")]
	setPedAnimation(source, "ped", walkstyle, true)
	setTimer( function(pl)
		setPedAnimation(pl, "ped", walkstyle, 1,false)
		bindKey(pl,"lshift", "down", BindStopwalk )
	end, 50, 1, source )
end

function BindStopwalk(pl)
	setPedAnimation(pl,"ped",walkstyle,0,false,false,false,false)
	unbindKey(pl,"lshift","down",BindStopwalk)
end

function cmd_q( )
	kickPlayer ( source, source, "Вы покинули сервер." )
end

function cmd_r(args)
	if args[1] ~= nil then
		local msg = ""
		for i=1,#args do
			msg = msg.." "..args[i]
		end
		FactionSendMessage(source,msg)
	end
end
function cmd_rb(args)
	if args[1] ~= nil then
		local msg = ""
		for i=1,#args do
			msg = msg.." "..args[i]
		end
		FactionSendMessage(source,msg,true)
	end
end

function cmd_invite(args)
	if isLeader(source) then

	else
		triggerClientEvent()
	end
end

function cmd_uninvite(args)

end

function cmd_setrank(args)
	FactionSetRankName(source,args[1],args[2])
end	

function cmd_members()
	if getElementData(source,"faction") ~= 0 then
		local qh = dbQuery(function(qh,sourcePlayer)
			local result = dbPoll(qh,0)
			if result then
				triggerClientEvent(sourcePlayer,"outputChatMessage",sourcePlayer,"Онлайн фракции: ")	
				for _,row in ipairs(result) do
					player = getPlayer(row.nick)
					triggerClientEvent(sourcePlayer,"outputChatMessage",sourcePlayer,row.nick.."[ "..getElementData(player,"id").." ]")
				end
				dbFree(qh)
			end
		end,{source},dbHandle,"SELECT `id`,`nick` FROM `online` WHERE `fr_id`=?",getElementData(source,"faction"))
	end
end

function cmd_pesc(args)
	if getElementFaction(source) == 1 then
		local player = getPlayer(args[1])
		if player and player ~= source then
			if not(getElementFaction(player) == 1) then
				setElementData(player,"pesc",true)
			end
		end
	end
end

function cmd_pbase()

end

function cmd_dc(args)
	if getElementFaction(source) == 1 then

	end
end

function cmd_cuff(args)
	local cop = source
	if getElementFaction(source) == 1 then
		local arrested = getPlayerByIdOrNick(args[1])
		if arrested and arrested ~= cop then
			local x,y,z = getElementPosition(cop)
			local x1,y1,z1 = getElementPosition(arrested)
			if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 5 then
				setTimer(function()
					local idle = getPlayerIdleTime(arrested)
					if idle >= 3000 then
						local arrestedtoggles = {"left","right","forwards","backwards","jump","sprint"}
						for i=1,#arrestedtoggles do
							toggleControl(arrested,arrestedtoggles[i],false)
						end
					end
				end,3000,1)
			end
		end
	end
end

function cmd_uncuff(args)
	local cop = source
	if getElementFaction(source) == 1 then
		local unarrested = getPlayerByIdOrNick(args[1])
		if unarrested then
			local x,y,z = getElementPosition(cop)
			local x1,y1,z1 = getElementPosition(unarrested)
			if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 5 then
				setTimer(function()
					local idle = getPlayerIdleTime(unarrested)
					if idle >= 3000 then
						local arrestedtoggles = {"left","right","forwards","backwards","jump","sprint"}
						for i=1,#arrestedtoggles do
							toggleControl(unarrested,arrestedtoggles[i],true)
						end
					end
				end,3000,1)
			end
		end
	end
end


function cmd_search()

end

function cmd_searchtr()

end

function cmd_searchhou()

end

function cmd_wanted()

end

function cmd_pdlic()

end

function cmd_addcar(args)
	if args then
		local qh = dbQuery(function(qh,sourcePlayer,args)
			local result = dbPoll(qh,0)
			if result then
				for k,row in ipairs(result) do
					if row.alevel > 0 then
						dbExec(dbHandle,"INSERT INTO `vehicles` (`carid`, `playerid`, `modelid`, `number`, `sx`, `sy`, `sz`, `rx`, `ry`, `rz`, `r`, `g`, `b`) VALUES (NULL, '"..row.id.."', '"..args[1].."', 'POSJ', '0', '0', '10', '0', '0', '0', '"..args[2].."', '"..args[3].."', '"..args[4].."');")
						local veh = createVehicle(args[1],0,0,10,0,0,0,'POSJ')
						setElementData(veh,"pid",row.id)
						setVehicleColor(veh,args[2],args[3],args[4])
					end
				end
			end
		end,{source,args},dbHandle,"SELECT `alevel`,`id` FROM `online` WHERE `nick`='"..getElementData(source,"nick").."'")
	end
end

function cmd_park()
	local veh = getPedOccupiedVehicle(source)
	if getElementData(veh,"pid") == getElementData(source,"tableid") then
		local x,y,z = getElementPosition(veh)
		local rX,rY,rZ = getElementRotation(veh)
		dbExec(dbHandle,"UPDATE `vehicles` SET `sx` = '"..x.."', `sy` = '"..y.."', `sz` = '"..z.."', rx = '"..rX.."', ry = '"..rY.."', rz='"..rZ.."' WHERE `vehicles`.`carid` = '"..getElementData(veh,"id").."'")
		triggerClientEvent(source,"outputChatMessage",source,"Вы успешно перепарковали ваше авто!")
	else
		triggerClientEvent(source,"outputChatMessage",source,"Это не ваше ТС!")
	end
end

function cmd_getpos()
	triggerClientEvent(client,"copyPosToClipboard",client)
end

function cmd_startlayout()
	--if isHaveBuildingAccept(source) then
		triggerClientEvent(client,"startBuilding",client)
	--end
end

function cmd_drawgrid()
	triggerClientEvent(client,"showGrid",client)
end