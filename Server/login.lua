function onLogIn(nick, pass)
	nick = removeHex(nick)
	isRegistered(nick, 
		function(state)
			if state then
				triggerClientEvent(lp, "outputChatMessage", lp, "Аккаунт с таким никнеймом не найден, пожалуйста зарегистрируйтесь.", "#990000")
			else
				
			end
		end
	)
end

function onSignIn(lp, nick, pass,email)
	nick = removeHex(nick)
	options = {
		formFields = {
			username=nick,
			email=email,
			password=pass,
		},
	}
	fetchRemote("https://forum.lw-rp.tk/reg.php", options, regCallback,{lp,nick})
end

function regCallback(responseData,errno,lp,nick)
	if type(errno) == "table" then
		responseData = fromJSON(responseData)
		if tonumber(responseData.code) == 1 then
			iprint(getPlayerName(lp))
			setElementData(lp, "logged", true)
			triggerClientEvent(lp, "outputChatMessage", lp, "Внимание, "..nick.." вы зарегистрирвали свой аккаунт на форум(forum.lw-rp.tk)")
			triggerClientEvent(lp, "outputChatMessage", lp, "Чтобы войти в следующий раз введите свой никнейм: "..nick..".")
			fadeCamera(lp, true)
			spawnPlayer(lp,0,0,0,0,162)
			triggerClientEvent(lp, "endSignUp",lp)
			setElementData(lp, "nick",  nick)
			showCursor(lp,true)
		elseif tonumber(responseData.code) == 2 then
			triggerClientEvent(lp, "errorSignUp", lp)
		end
	else
		
	end
end

function onPlayerOff( )
	local tableid = getElementData(source,"tableid")
	local vehicles = getElementsByType("vehicle")
	for i,vehicle in ipairs(vehicles) do
		if tableid == getElementData(vehicle,"pid") then
			destroyElement(vehicle)
		end
	end
end

function onEndRegister( thePlayer, skin )
	setElementData(thePlayer, "skin", skin)	
	spawnPlayer(thePlayer, 0,0,0, 50,skin)
	fadeCamera(thePlayer,true)
	setCameraTarget(thePlayer,thePlayer)
	setElementInterior(thePlayer,0)
end

function onAuth(userid)
	local qh = dbQuery(authCallback,{client}, dbHandle, "SELECT * FROM `accounts` WHERE `forumid` ="..userid)
end

function authCallback(qh,client)
	local result = dbPoll( qh, 0 )
	if result then
		triggerClientEvent(client,"onReturnCharacters",client,result)
	end
end

function onSelectCharacter(table)
	faction = table.faction
	if faction > 0 then
		spawnPlayer(source, Faction_spawn[faction][1], 50, table.skin)
		setCameraTarget(source,source)
		setElementInterior(source,Faction_spawn[faction][2])
	else
		spawnPlayer(source, 391.658203125, -1524.560546875, 32.266296386719, 50, table.skin)
		setCameraTarget(source,source)
	end
	setPlayerMoney(source,table.money,false)
	parsePlayerVehicles(table)
	dbExec(dbHandle,"INSERT INTO `online`(`id`, `nick`, `fr_id`, `alevel`) VALUES ("..getElementData(source,"id")..",'"..table.nick.."',"..table.faction..","..table.admin..")")
end

function onEndCreateCharacter(nick,skin,spawn,gender)
	local qh = dbQuery(function(qh,client,nick,skin,spawn,gender)
		local result = dbPoll(qh,0)
		if #result == 0 then
			if gender == "Мужской" then 
				gender = 1 
				walkstyle = 1
			else 
				gender = 2 
				walkstyle = 4
			end
			dbExec(dbHandle,"INSERT INTO `accounts` (`nick`, `gender`, `skin`, `walkstyle`, `money`, `level`, `exp`, `faction`, `leader`, `admin`, `forumid`) VALUES ( '"..nick.."', '"..gender.."', '"..skin.."', '1', '1000', '1', '0', '0', '0', '0', '"..getElementData(client,"forumid").."')")
			triggerClientEvent(client,"onSuccessCharacter",client)
			spawnPlayer(client,0,0,0,0,skin)
			setPlayerMoney(client,1000)
			setElementData(client,"nick",nick)
			setElementData(client,"logged",true)
			setElementData(client,"walkstyle",walkstyle)
			setCameraTarget(client,client)
			showCursor(client,false)
		else
			triggerClientEvent(client,"onErrorCharacter",client)
		end
	end,{client,nick,skin,spawn,gender},dbHandle,"SELECT `nick` FROM `accounts` WHERE nick='"..nick.."'")
end

addEvent("onPlayerLogIn", true)
addEvent("onClientEndRegister", true)
addEvent("onPlayerStartSignUp", true)
addEvent("getCharacters", true)
addEvent("onClientSelectCharacter", true)
addEvent("onEndCreateCharacter", true)

addEventHandler("onPlayerLogIn", getRootElement(), onLogIn)
addEventHandler("onPlayerStartSignUp", getRootElement(), onSignIn)
addEventHandler("onClientEndRegister",root,onEndRegister)
addEventHandler( "onPlayerQuit", getRootElement(), onPlayerOff )
addEventHandler("onClientSelectCharacter",root,onSelectCharacter)
addEventHandler("getCharacters",root,onAuth)
addEventHandler("onEndCreateCharacter",root,onEndCreateCharacter)