gInteractiveMenuOpened = false
gInteractivities = {}
gInteractivitiesCount = 0
gInteractivitiesShaders = {
    ped = nil,
    veh = nil
}
local ped = createPed(1,130.37341308594, -10.399103164673, 1.5674175024033,0,false)
local ped2 = createPed(0,130.53541564941, -12.794979095459, 1.5724601745605,0,false)
local sphereped = createColSphere(130.37341308594, -10.399103164673, 1.5674175024033,1.2)
local sphereped2 = createColSphere(130.53541564941, -12.794979095459, 1.5724601745605,1.2)
attachElements(sphereped,ped)
attachElements(sphereped2,ped2)

function openInteractionMenu(btn,press)
    if press then
        if getKeyState("mouse2") then
            if btn == "e" then
                outputDebugString(gInteractivitiesCount)
                if not(gInteractiveMenuOpened) then
                    if gInteractivitiesCount > 1 then
                        gInteractiveMenuOpened = true
                        addEventHandler("onClientCursorMove", root, processCursorMove)
                        gInteractivitiesShaders.ped = dxCreateShader("Shaders/ped-stroke.fx",0,0,true,"ped,object")
                        gInteractivitiesShaders.veh = dxCreateShader("Shaders/veh-stroke.fx",0,0,true,"vehicle")
                        showCursor(true)
                        startTickCount = getTickCount()
                        setPlayerComponentVisible("chattoggle",false)
                    elseif gInteractivitiesCount == 1 then
                        for i,colTable in pairs(gInteractivities) do
                            colTable.func(source,colTable)
                        end
                    end
                else
                    gInteractiveMenuOpened = false
                    closeInteractiveMenu()
                    showCursor(false)
                    removeEventHandler("onClientCursorMove", root, processCursorMove)
                end
            end
        end
    end
end
addEventHandler("onClientKey",root,openInteractionMenu)

function getHoveredElement(worldX, worldY, worldZ) --the position of the mouse in world space
    local cameraX, cameraY, cameraZ = getCameraMatrix()
    
    local hit, x, y, z, element = processLineOfSight(cameraX, cameraY, cameraZ, worldX, worldY, worldZ, false)
    
    if not hit or not element then
        return false
    end
    
    return element
end

function processCursorMove(cursorX, cursorY, absX, absY, worldX, worldY, worldZ)
    local element = getHoveredElement(worldX, worldY, worldZ) --Get the current hovered element
    
    if not element then
        return false
    end
    local x, y, z = getElementPosition(element)
    for i,inTable in ipairs(gInteractivities) do
        if inTable.element == element then
            if not(inTable.hovered) then
                inTable.hovered = true
                addStrokeShader(element)
            end
        else
            if inTable.hovered then
                removeStrokeShader(element)
                inTable.hovered = false
            end
        end
    end
end


function addStrokeShader(element)
    if getElementType(element) == "player" then
        engineApplyShaderToWorldTexture(gInteractivitiesShaders.ped, "*",element)
    elseif getElementType(element) == "vehicle" then
        engineApplyShaderToWorldTexture(gInteractivitiesShaders.veh, "*",element)
    end
end

function removeStrokeShader(element)
    if getElementType(element) == "player" then
        engineRemoveShaderFromWorldTexture(gInteractivitiesShaders.ped, "*",element)
    elseif getElementType(element) == "vehicle" then
        engineRemoveShaderFromWorldTexture(gInteractivitiesShaders.veh, "*",element)
    end
end

function closeInteractiveMenu()
    for i,inTable in pairs(gInteractivities) do
        if inTable.element then
            if inTable.hovered then
                inTable.hovered = false
                removeStrokeShader(inTable.element)
            end
        end
    end
end

function onPlayerIntClick(colTable)
    
end

function onVehicleIntClick()
    
end

function onObjectIntClick()

end

function addInteractiveColshape()
    local attach = getElementAttachedTo(source)
    if inspect(attach) ~= inspect(localPlayer) then
        if getElementType(attach) == "player" then
            label = getElementData(attach,"nick")
            func = onPlayerIntClick
        elseif getElementType(attach) == "vehicle" then
            label = getVehicleName(attach)
            func = onVehicleIntClick
        elseif getElementType(attach) == "object" then
            label = ""
            func = onVehicleIntClick
        end
        gInteractivities[source] = {
            label = label,
            func = func,
            element = attach,
            hovered = false
        }
        gInteractivitiesCount = gInteractivitiesCount+1
    end
end
addEventHandler("onClientColShapeHit",root,addInteractiveColshape)

function removeInteractiveColshape(colshape)
    gInteractivities[colshape] = nil
    gInteractivitiesCount = gInteractivitiesCount - 1
end
addEventHandler("onClientColShapeLeave",root,removeInteractiveColshape)
setDevelopmentMode(true)