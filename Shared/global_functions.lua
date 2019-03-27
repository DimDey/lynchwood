local originalGetPlayerCount = getPlayerCount -- Store the original getPlayerCount function to a variable
function removeHex(text, digits) -- функция с вики.
    assert(type(text) == "string", "Bad argument 1 @ removeHex [String expected, got " .. tostring(text) .. "]")
    assert(digits == nil or (type(digits) == "number" and digits > 0), "Bad argument 2 @ removeHex [Number greater than zero expected, got " .. tostring(digits) .. "]")
    return string.gsub(text, "#" .. (digits and string.rep("%x", digits) or "%x+"), "")
end

function isLogged(thePlayer)
	return getElementData(thePlayer, "logged")
end

function realTime() -- спёрто с МТА вики
    local realtime = getRealTime()

    setTime(realtime.hour, realtime.minute)
    setMinuteDuration(60000)
end
addEventHandler("onResourceStart", getResourceRootElement(), realTime)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end

function getPlayer( player )
    if type(player) == "number" then
        return getPlayerByID(player)
    elseif isElement( player ) then
        return player
    end
end

function getPlayerByNick( nick )
    for k, v in ipairs(getElementsByType("player")) do 
        if getElementData(v,"nick") == nick then
            return v
        end
    end 
end

function getAlevel( player )
    return getElementData( player, "alevel")
end

function isLogged(thePlayer) -- проверка на авторизацию
	return getElementData(thePlayer, "logged")
end

function getPlayerCount()
    -- If originalGetPlayerCount is defined, that means that this function is executed serverside.
    -- The next line returns the result of the original function if it's defined. If not, it counts the number of player elements (to also work clientside).
    return originalGetPlayerCount and originalGetPlayerCount() or #getElementsByType("player")
end

function table.clear(t)
    count = #t
    for i=0, count do t[i]=nil end
end

function math.round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function math.percent(number,percent)
    return (number/100)*percent
end