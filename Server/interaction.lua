local testCol = createColRectangle(10,10,100,100)
local testCol = createColRectangle(10,10,100,100)
function onPlayerHitColshape(player)
    outputDebugString("test")
    triggerClientEvent(player,"onClientColshapeHit",player,source,"TEST","testEvent")
end
addEventHandler("onColShapeHit",root,onPlayerHitColshape)

function onPlayerLeaveColshape(player)
    if eventName == "onResoureStop" then
        triggerClientEvent(player,"onClientColshapeLeave",player,source)
    end
end
addEventHandler("onColShapeLeave",root,onPlayerLeaveColshape)