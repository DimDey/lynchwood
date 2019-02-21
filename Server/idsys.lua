function assignID(lp) -- перебирает ид, когда игрок подключается, через цикл for, и если ids[i] пусто,то оно заполняется данными игрока.
    for i=1,getMaxPlayers() do 
        if not ids[i] then 
			ids[i] = source 
            setElementData(source,"id",i)
            break 
        end 
	end
end 
addEventHandler("onPlayerJoin",root,assignID) 
  
function startup(res) -- когда ресурс запускается, то сервер проверяет игроков на наличие данных ид в игроке.
	if res == resource then
	    for k, v in ipairs(getElementsByType("player")) do 
	        local id = getElementData(v,"id") 
			if id then 
				ids[id] = v 
			end 
	    end 
	end
end 
addEventHandler("onResourceStart",resourceRoot,startup) 

function freeID() -- освобождение ид, когда игрок выходит.
    local id = getElementData(source,"id") 
    if not id then return end 
	ids[id] = nil 
end 
addEventHandler("onPlayerQuit",root,freeID) 

function getPlayerByID(id) -- взять игрока через ид.
    local player = ids[id] 
    return player or false 
end
addEventHandler("getPlayerByID",root,getPlayerByID)
addEvent("getPlayerByID",true)