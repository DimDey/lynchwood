function onSignIn(nick, pass, email)
	local qh = dbQuery(regCallback,{client,nick,pass,email},dbHandle, "SELECT * FROM `accounts` WHERE `nick`='"..nick.."' AND `email`='"..email.."'")
end

function regCallback(qh,client,nick,pass,email)
	local result = dbPoll(qh,0)
	if result then
		if #result == 0 then
			pass = base64Encode(pass)
			dbExec(dbHandle,"INSERT INTO `accounts` (`id`, `nick`, `email`, `pass`, `faction`, `admin`) VALUES (NULL, '"..nick.."', '"..email.."', '"..pass.."', '0', '0');")
			
			triggerClientEvent(client,"onSuccessEdits",client)
		else
			triggerClientEvent(client,"onErrorEdits",client)
		end
	end
	dbFree(qh)
end

function onPlayerOff( )
	local tableid = getElementData(source,"tableid")
	local vehicles = getElementsByType("vehicle")
	for i,vehicle in ipairs(vehicles) do
		if tableid == getElementData(vehicle,"pid") then
			destroyElement(vehicle)
		end
	end
	dbExec(dbHandle,"DELETE FROM `online` WHERE `online`.`nick` = '"..getElementData(source,"nick").."'")
end

function clearOnline()
	dbExec(dbHandle,"TRUNCATE `online`")
end
addEventHandler("onResourceStop",resourceRoot,clearOnline)

function onAuth(login,pass)
	pass = base64Encode(pass)
	local qh = dbQuery(authCallback,{client,pass}, dbHandle, "SELECT * FROM `accounts` WHERE `nick` ='"..login.."'")
end

function authCallback(qh,client,pass)
	local result = dbPoll( qh, 0 )
	if result then
		for i,row in ipairs(result) do
			if row.pass == pass then
				spawnPlayer(client,0,0,0,0,98,0,0)
				setCameraTarget(client,client)
				triggerClientEvent(client,"successLogIn",client)
				dbExec(dbHandle,"INSERT INTO `online` (`id`, `nick`, `fr_id`, `alevel`) VALUES ('"..row.id.."', '"..row.nick.."', '"..row.faction.."', '"..row.admin.."')")
				setElementData(client,"nick",row.nick)
				setElementData(client,"logged",true)
				setElementData(client,"faction",tonumber(row.faction))
				setElementData(client,"alevel",row.admin)
			else
				triggerClientEvent(client,"errorLogIn",client,"pass")
			end
		end	
	else
		triggerClientEvent(client,"errorLogIn",client,"login")
	end
	dbFree(qh)
end

function onSelectCharacter(table)
	--dbExec(dbHandle,"INSERT INTO `online`(`id`, `nick`, `fr_id`, `alevel`) VALUES ("..getElementData(source,"id")..",'"..table.nick.."',"..table.faction..","..table.admin..")")
end
addEvent("onPlayerLogIn",true)
addEvent("onPlayerStartSignUp", true)
addEvent("onEndCreateCharacter", true)

addEventHandler("onPlayerLogIn", getRootElement(), onAuth)
addEventHandler("onPlayerStartSignUp", getRootElement(), onSignIn)
addEventHandler( "onPlayerQuit", getRootElement(), onPlayerOff )