ElementStorage = {}

_setElementData = setElementData
_getElementData = getElementData
_getAllElementData = getAllElementData

function setElementData(element,key,value)
    if element then
        local oldValue = ElementStorage[element].key
        ElementStorage[element].key = value
        triggerEvent("onElementDataUpdate",element,key,oldValue,value)
        return true
    end
end

function getElementData(element,key)
    if ElementStorage[element].key then
        return ElementStorage[element].key
    else
        return false
    end
end

function getAllElementData(element)
    return ElementStorage[element]
end


function consoleLogUpdates(key,old,new)
    outputConsole(source.." has been update the data with key: "..key..". Old Value: "..old.." New: "..new)
end

addEvent("onElementDataUpdate",true)
addEventHandler("onElementDataUpdate",root,consoleLogUpdates)