function mainBuildMenu()
    if getKeyState("mouse2") then
        
    end
end

function startBuild()
    x,y,z = getElementPosition(lp)
    triggerEvent("doSetFreecamEnabled",lp,x+1,y+1,z)
    setElementAlpha(lp,0)
    addEventHandler("onClientRender",root,mainBuildMenu)
    addEventHandler("onClientKey",root, moveHouseObject)
    houseobject = createObject(9323,x+5,y,z)
    showCursor(true)
    setElementData(localPlayer,"housebuilding",true)
end
addEvent("startBuilding",true)
addEventHandler("startBuilding",root,startBuild)

function isFreecamEnabled()
	return getElementData(localPlayer,"housebuilding")
end

function removeFreecam()
    if isFreecamEnabled() then
        triggerEvent("doSetFreecamDisabled",lp)
        setElementAlpha(lp,255)
        setElementData(localPlayer,"housebuilding",false)
    end
end
addEventHandler("onClientResourceStop",resourceRoot,removeFreecam)