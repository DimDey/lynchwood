function sendMessageToAll(player,chat_range,color,...) -- Отправка сообщений всем, кто находится рядом
	if chat_range == nil then
	 	chat_range = 15
	end
    if color == nil then
		local px,py,pz=getElementPosition(player) -- взять коордитаны игрока
	    for _,v in ipairs(getElementsByType("player")) do -- перебор игроков 
	       if isPlayerInRangeOfPoint(v,px,py,pz,chat_range) then  -- если игрок рядом
	          triggerClientEvent(v, "outputChatMessage",v,...,msg_color) -- отправить сообщение игрокам, которые находятся рядом
	       end 
	    end
	else
		local px,py,pz=getElementPosition(player) -- взять коордитаны игрока
	    for _,v in ipairs(getElementsByType("player")) do -- перебор игроков 
	       if isPlayerInRangeOfPoint(v,px,py,pz,chat_range) then  -- если игрок рядом
	          triggerClientEvent(v, "outputChatMessage",v,...,color) -- отправить сообщение игрокам, которые находятся рядом
	       end 
	    end
	end
end 
addEvent("sendMessage",true)
addEventHandler("sendMessage",root,sendMessageToAll)

function isPlayerInRangeOfPoint(player,x,y,z,range) 
   local px,py,pz=getElementPosition(player) 
   if ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5 <= range/3 then
   		msg_color = "#FFFFFF"
   elseif ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5 <= range/2 then
   		msg_color = "#c0c0c0"
   elseif ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5 <= range/1.5 then
   		msg_color = "#696969"
   end
   if range <= 10 then
   		msg_color = "#FFFFFF"
   end
   return ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5<=range
end 