local loginText = dxMaskTexture("Images/auth-btn.png",screenW * 0.5,screenH * 0.5)
local regText = dxMaskTexture("Images/reg-btn.png",screenW * 0.5,screenH * 0.5)
local loginMask = dxMaskTexture("Images/background-auth.png",screenW * 0.5,screenH * 0.5)
local regMask = dxMaskTexture("Images/background-reg.png",screenW * 0.5,screenH * 0.5)
local cX,cY,cZ = math.random(0,2000),math.random(0,2000),math.random(5,100)
local lX,lY,lZ = math.random(0,2000),math.random(0,2000),math.random(5,100)

Buttons = {
    login = {
        x = 0,
        y = -(screenH * 0.5),
        loginY = screenH,
        textcolor = white,
        func = nil
    },
    register = {
        x = 0,
        y = screenH,
        textcolor = white,
        func = nil
    }
}

function onClientJoinServer()
    fadeCamera(true,5)
    showCursor(true)
end
addEventHandler("onClientResourceStart",resourceRoot,onClientJoinServer)

function movePlayerCamera()
    cX = cX - 0.1
    cY = cY - 0.1
    lX = lX - 0.1
    setCameraMatrix(cX,cY,cZ,lX,lY,lZ)
end
addEventHandler("onClientRender",root,movePlayerCamera)

function dxDrawMainMenu()
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/background-auth.png")

    dxDrawRectangle(0,0,screenW * 0.5,screenH * 0.5, tocolor(29,29,33,155))
    dxDrawRectangle(0,Buttons.login.y,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,195))
    
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/auth-btn.png")
    
    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/background-reg.png")

    dxDrawRectangle(0,screenH * 0.5,screenW * 0.5,screenH * 0.5, tocolor(29,29,33,155))
    dxDrawRectangle(0,Buttons.register.y,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,195))

    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/reg-btn.png")

    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.01,screenH * 0.08,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.08,screenH * 0.01,SERVERCOLORS.GENERAL)

    dxDrawRectangle(screenW * 0.9,screenH * 0.82,screenH * 0.01,screenH * 0.08,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.855,screenH * 0.89,screenH * 0.08,screenH * 0.01,SERVERCOLORS.GENERAL)
end
addEventHandler("onClientRender",root,dxDrawMainMenu)

function onClientMove()
    if isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5) then
        animateBtn(Buttons.login,0)
    end
    if isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
        animateBtn(Buttons.register,screenH * 0.5)
    end
    if math.floor(Buttons.login.y) > -(screenH * 0.5) then
        if not(isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5)) then
            animateBtn(Buttons.login,-(screenH * 0.5))
        end
    end
    if math.floor(Buttons.register.y) < screenH then
        if not(isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5)) then
            animateBtn(Buttons.register,screenH)
        end
    end
end
addEventHandler("onClientRender",root,onClientMove)

function animateChange()
    local rectangle = {
        x = -100,
        y = 0,
        width = screenW * 0.5,
        height = screenH
    }
    local startTime = getTickCount()
    local func
    local rt = dxCreateRenderTarget(screenW * 0.5,screenH,true)
    func = function()
        local now = getTickCount()
        local endTime = startTime + (3500 * 10)
        local elapsedTime = now - startTime
        local duration = endTime - startTime
        local progress = elapsedTime / duration
        rectangle.x = interpolateBetween(rectangle.x,0,0,screenW * 0.5,0,0,progress,"Linear")
        dxSetRenderTarget(rt,true)
        dxDrawRectangle(rectangle.x,rectangle.y,rectangle.width,rectangle.height,SERVERCOLORS.GENERAL)
        dxSetRenderTarget()
        dxDrawImage(0,0,screenW * 0.5,screenH,rt)
        if rectangle.x == screenW * 0.5 then
            removeEventHandler("onClientRender",root,func)
        end
        
    end
    addEventHandler("onClientRender",root,func)
end

function onClientClick()
    if isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5) then
        onClientClickAuth()
    elseif isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
        animateBtn(Buttons.register,screenH * 0.51)
    end
    animateChange()
end
addEventHandler("onClientClick",root,onClientClick)

function animateBtn(btnTable,y,duration) 
    duration = duration or 1000
    local startTimer = getTickCount()
    local func
    func = function()
        local now = getTickCount()
        local elapsedTime = now - startTimer
        local duration = duration * 10
        local progress = elapsedTime / duration
        if btnTable.y ~= y then
            btnTable.y = interpolateBetween(btnTable.y,0,0,y,0,0,progress,"Linear")
        else
            removeEventHandler("onClientRender",root,func)
        end
    end
    addEventHandler("onClientRender",root,func)
end