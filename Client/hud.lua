function dxDrawLogo()
    if isLogged(lp) and not(getPlayerComponentVisible("camerafaded")) then
        --dxDrawText(getPlayerMoney(), screenW * 0.9222, screenH * 0.1244, screenW * 0.9951, screenH * 0.1467, tocolor(255, 255, 255, 255), 1.00, font_montlightX, "center", "center")
    end
end
addEventHandler("onClientRender",root,dxDrawLogo)

function removeHudElements()
    local comps = {"vehicle_name","radar","area_name"}
    for _,name in ipairs(comps) do
        setPlayerHudComponentVisible(name,false)
    end
end
addEventHandler("onClientResourceStart",resourceRoot,removeHudElements)