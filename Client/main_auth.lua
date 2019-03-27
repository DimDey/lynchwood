local loginText = dxMaskTexture("Images/auth-btn.png",screenW * 0.5,screenH * 0.5)
local regText = dxMaskTexture("Images/reg-btn.png",screenW * 0.5,screenH * 0.5)
local loginMask = dxMaskTexture("Images/background-auth.png",screenW * 0.5,screenH * 0.5)
local regMask = dxMaskTexture("Images/background-reg.png",screenW * 0.5,screenH * 0.5)
local cX,cY,cZ = math.random(0,2000),math.random(0,2000),math.random(5,100)
local lX,lY,lZ = math.random(0,2000),math.random(0,2000),math.random(5,100)
animateRectangles = {math.random(0,21),math.random(0,21),math.random(0,21),math.random(0,21)}
edits = {
    login = {
        color = white,
        bgcolor = tocolor(0,0,0,0),
        textcolor = white
    },
    email = {
        color = white,
        bgcolor = tocolor(0,0,0,0),
        textcolor = white
    },
    pass = {
        color = white,
        bgcolor = tocolor(0,0,0,0),
        textcolor = white
    }
}
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
selectedMenu = "general"
animList = {}


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
            removeEventHandler("onClientRender",root,func,true,"low")
        end
        
    end
    addEventHandler("onClientRender",root,func,true,"low")
end

function onClientClick()
    if isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5) then
        onClientClickAuth()
        selectedMenu = "login"
        animateChange()
    elseif isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
        animateBtn(Buttons.register,screenH * 0.51)
        selectedMenu = "register"
        animateChange()
        onClientClickRegister()
    end
    
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
            animList[func] = nil
        end
    end
    animList[func] = true
    addEventHandler("onClientRender",root,func)
end

function onClientKeyInMenu(btn,press)
    if press then
        if btn == "backspace" then
            if not(dgsGetFocusedGUI()) then
                if selectedMenu ~= "general" then
                    addEventHandler("onClientRender",root,onClientMove)
                    addEventHandler("onClientClick",root,onClientClick)
                    addEventHandler("onClientRender",root,dxDrawMainMenu)

                    edits.login.color = white
                    edits.login.bgcolor = tocolor(0,0,0,0)
                    edits.login.textcolor = white
                    edits.login.success = nil

                    edits.pass.color = white
                    edits.pass.bgcolor = tocolor(0,0,0,0)
                    edits.pass.textcolor = white
                    edits.pass.success = nil

                    destroyElement(logEdit)
                    destroyElement(passEdit)

                    if selectedMenu == "login" then
                        
                        Buttons.login.y = 0
                        Buttons.register.y = screenH
                        selectedMenu = "general"
                        removeEventHandler("onClientRender",root,dxDrawAuthMenu)
                        removeEventHandler("onClientClick",root,onClickLoginBtn)
                        removeEventHandler("onClientRender",root,onClientMoveLogin)
                        removeEventHandler("onDgsEditAccepted",root,onAcceptLogEdits)

                    elseif selectedMenu == "register" then
                        selectedMenu = "general"
                        edits.email.color = white
                        edits.email.bgcolor = tocolor(0,0,0,0)
                        edits.email.textcolor = white
                        edits.email.success = nil

                        destroyElement(emailEdit)
                        removeEventHandler("onClientRender",root,dxDrawRegMenu)
                        removeEventHandler("onDgsEditAccepted",root,onAcceptRegEdits)
                        removeEventHandler("onClientClick",root,onClientClickRegBtn)
                        removeEventHandler("onClientKey",root,onClientKeyInMenu)

                    end
                    animateChange()
                    for i,func in pairs(animList) do
                        removeEventHandler("onClientRender",root,i)
                    end
                end
            end   
        end
    end
end
addEventHandler("onClientKey",root,onClientKeyInMenu)