gInteractiveMenuOpened = false
gInteractivities = {}
gInteractivitiesCount = 0
gInteractivitiesShader = nil
function openInteractionMenu(btn,press)
    if press then
        if getKeyState("mouse2") then
            if btn == "e" then
                outputDebugString(gInteractivitiesCount)
                if gInteractivitiesCount > 1 then
                    openInteractiveMenu()
                    showCursor(true)
                    startTickCount = getTickCount()
                else
                    for i,colTable in pairs(gInteractivities) do
                        triggerEvent(colTable.onClick,source)
                    end
                end
            end
        end
    end
end
addEventHandler("onClientKey",root,openInteractionMenu)

function openInteractiveMenu()
    for i,intTable in pairs(gInteractivities) do
        local elType = getElementType(intTable.element)
        local elementType = getElementType( element )
		
    end

end

function addInteractiveColshape(colshape,colname,trevent,element)
    gInteractivities[colshape] = {
        label = colname,
        interactiveelement = element,
        onClick = trevent
    }
    gInteractivitiesCount = gInteractivitiesCount+1
    return true
end
addEvent("onClientColshapeHit",true)
addEventHandler("onClientColshapeHit",root,addInteractiveColshape)
function removeInteractiveColshape(colshape)
    gInteractivities[colshape] = nil
    gInteractivitiesCount = gInteractivitiesCount-1
end
addEvent("onClientColshapeLeave",true)
addEventHandler("onClientColshapeLeave",root,removeInteractiveColshape)
setDevelopmentMode(true)

function testEvent()
    outputDebugString("testEvent")
end
addEvent("testEvent",true)
addEventHandler("testEvent",root,testEvent)