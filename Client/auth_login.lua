function onClientClickAuth()
    removeEventHandler("onClientRender",root,onClientMove)
    removeEventHandler("onClientClick",root,onClientClick)
    removeEventHandler("onClientRender",root,dxDrawMainMenu)

    animateBtn(Buttons.login,screenH,2)

    addEventHandler("onClientRender",root,dxDrawAuthMenu)
    addEventHandler("onClientClick",root,onClickLoginBtn)
    addEventHandler("onClientRender",root,onClientMoveLogin)
    addEventHandler("onDgsEditAccepted",root,onAcceptLogEdits)
    
    logEdit  =  dgsCreateEdit(screenW * 0.11,screenH * 0.14,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    passEdit = dgsCreateEdit(screenW * 0.11,screenH * 0.32,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    if not(ceraReg) then
        ceraReg = dgsCreateFont("Fonts/CeraPro-Regular.ttf",15,false,"antialiased")
    end
    dgsSetFont(logEdit,ceraReg)
    dgsSetFont(passEdit,ceraReg)
    dgsEditSetMasked(passEdit,true)
    yPos = screenH
end

function dxDrawAuthMenu()
    if not(fontawesome) then
        fontawesome = getFont("Fonts/fontawesome.ttf",15,false,"antialiased")
    end
    if not(bebasreg) then
        bebasreg = getFont("Fonts/BebasNeue Regular.otf",20,false,"antialiased")
    end
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/background-auth.png")
    dxDrawRectangle(0,0,screenW * 0.5,screenH * 0.5, tocolor(29,29,33,204))

    dxDrawLine(screenW * 0.05,0,screenW * 0.05,screenH * 0.5,tocolor(255,255,255,50),1)
    dxDrawLine(screenW * 0.45,0,screenW * 0.45,screenH * 0.5,tocolor(255,255,255,50),1)
    dxDrawLine(0,screenH * 0.05,screenW * 0.5,screenH * 0.05,tocolor(255,255,255,50),1)
    dxDrawLine(0,screenH * 0.45,screenW * 0.5,screenH * 0.45,tocolor(255,255,255,50),1)

    dxDrawRectangle(screenW * 0.05 - 1,animateRectangles[1],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.45 - 1,animateRectangles[2],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[3],screenH * 0.05 - 1,10,3,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[4],screenH * 0.45 - 1,10,3,SERVERCOLORS.GENERAL)
    for k,pos in ipairs(animateRectangles) do
        if k <= 2 then
            if animateRectangles[k] < screenH * 0.5 then
                
                animateRectangles[k] = animateRectangles[k]+0.2
            else
                animateRectangles[k] = -10
            end
        else
            if animateRectangles[k] < screenW * 0.5 then
                animateRectangles[k] = animateRectangles[k]+0.2
            else
                animateRectangles[k] = -10
            end
        end
    end
    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.01,screenH * 0.08,tocolor(255,106,20))
    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.08,screenH * 0.01,tocolor(255,106,20))
    dxDrawRectangle(screenW * 0.9,screenH * 0.82,screenH * 0.01,screenH * 0.08,tocolor(255,106,20))
    dxDrawRectangle(screenW * 0.855,screenH * 0.89,screenH * 0.08,screenH * 0.01,tocolor(255,106,20))

    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/background-login.png")
    dxDrawRectangle(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,tocolor(29,29,33,100))
    dxDrawRectangle(0,yPos,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,175))
    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/auth-btn.png")

    dxDrawText("НИКНЕЙМ",screenW * 0.1,screenH * 0.11,screenW * 0.1,screenH * 0.12,edits.login.textcolor,1,bebasreg)
    dxDrawText("ПАРОЛЬ",screenW * 0.1,screenH * 0.29,screenW * 0.1,screenH * 0.12,edits.pass.textcolor,1,bebasreg)


    dxDrawText("",screenW * 0.103,screenH * 0.15,screenW * 0.1,screenH * 0.14,edits.login.color,1,fontawesome)
    dxDrawText("",screenW * 0.103,screenH * 0.33,screenW * 0.1,screenH * 0.14,edits.pass.color,1,fontawesome)

    if edits.login.success then
        dxDrawText("",screenW * 0.4 - 30,screenH * 0.145,screenW * 0.1,screenH * 0.3,edits.login.color,1,fontawesome)
    elseif edits.login.success == false then
        dxDrawText("",screenW * 0.4 - 30,screenH * 0.145,screenW * 0.1,screenH * 0.3,edits.login.color,1,fontawesome)
    end
    if edits.pass.success then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.325,screenW * 0.1,screenH * 0.325,edits.pass.color,1,fontawesome)
    elseif edits.pass.success == false then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.325,screenW * 0.1,screenH * 0.325,edits.pass.color,1,fontawesome)
    end

    dxDrawRectangle(screenW * 0.1,screenH * 0.18,screenW * 0.3,2,edits.login.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.14,screenW * 0.3,screenH * 0.04,edits.login.bgcolor)

    dxDrawRectangle(screenW * 0.1,screenH * 0.36,screenW * 0.3,2,edits.pass.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.32,screenW * 0.3,screenH * 0.04,edits.pass.bgcolor)
    

end

function onClientMoveLogin()
    if isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
        loginAnim(screenH * 0.5) 
    else
        if yPos ~= screenH then
            loginAnim(screenH)
        end
    end
end

function onClickLoginBtn()
    if isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
        onAcceptLogEdits()
    end
end



function onAcceptLogEdits()
    local login = dgsGetText(logEdit)
    local pass = dgsGetText(passEdit)
    if string.find(login,'^%u%l+_%u%l+$') then
        edits.login.color = SERVERCOLORS.GENERAL
        edits.login.bgcolor = tocolor(255,106,19,51)
        edits.login.success = true
        edits.login.textcolor = tocolor(255,255,255)
    else
        edits.login.color = SERVERCOLORS.RED
        edits.login.bgcolor = tocolor(236,32,32,51)
        edits.login.success = false
        edits.login.textcolor = SERVERCOLORS.RED
    end
    dgsSetProperty(logEdit,"textColor",edits.login.textcolor)
    if string.len(pass) >= 6 then
        edits.pass.color = SERVERCOLORS.GENERAL
        edits.pass.bgcolor = tocolor(255,106,19,51)
        edits.pass.success = true
        edits.pass.textcolor = tocolor(255,255,255)
    else
        edits.pass.color = SERVERCOLORS.RED
        edits.pass.bgcolor = tocolor(236,32,32,51)
        edits.pass.success = false
        edits.pass.textcolor = SERVERCOLORS.RED
    end
    dgsSetProperty(passEdit,"textColor",edits.pass.textcolor)
    if edits.login.success and edits.pass.success then
        triggerServerEvent("onPlayerLogIn",localPlayer,login,pass)
    end
end

function loginAnim(y,duration) 
    duration = duration or 1000
    local startTimer = getTickCount()
    local func
    func = function()
        local now = getTickCount()
        local elapsedTime = now - startTimer
        local duration = duration * 10
        local progress = elapsedTime / duration
        if yPos ~= y then
            yPos = interpolateBetween(yPos,0,0,y,0,0,progress,"Linear")
        else
            removeEventHandler("onClientRender",root,func)
            animList[func] = nil
        end
    end
    animList[func] = true
    addEventHandler("onClientRender",root,func)
end

function onErrorLogIn(error)
    if error == "login" then
        edits.login.color = SERVERCOLORS.RED
        edits.login.bgcolor = tocolor(236,32,32,51)
        edits.login.success = false
        edits.login.textcolor = SERVERCOLORS.RED

        edits.pass.color = white
        edits.pass.bgcolor = tocolor(0,0,0,0)
        edits.pass.success = nil
        edits.pass.textcolor = tocolor(255,255,255)
    else
        edits.login.color = SERVERCOLORS.GENERAL
        edits.login.bgcolor = tocolor(255,106,19,51)
        edits.login.success = true
        edits.login.textcolor = tocolor(255,255,255)

        edits.pass.color = SERVERCOLORS.RED
        edits.pass.bgcolor = tocolor(236,32,32,51)
        edits.pass.success = false
        edits.pass.textcolor = SERVERCOLORS.RED
    end
    dgsSetProperty(logEdit,"textColor",edits.login.textcolor)
    dgsSetProperty(passEdit,"textColor",edits.pass.textcolor)
end
addEvent("errorLogIn",true)
addEventHandler("errorLogIn",root,onErrorLogIn)

function onSuccessLogIn()
    removeEventHandler("onClientRender",root,dxDrawAuthMenu)
    removeEventHandler("onClientClick",root,onClickLoginBtn)
    removeEventHandler("onClientRender",root,onClientMoveLogin)
    removeEventHandler("onDgsEditAccepted",root,onAcceptLogEdits)
    removeEventHandler("onClientRender",root,movePlayerCamera)
    removeEventHandler("onClientKey",root,onClientKeyInMenu)
    setCameraTarget(localPlayer)
    
    destroyElement(logEdit)
    destroyElement(passEdit)
    destroyElement(bebasreg)
    destroyElement(fontawesome)
    showCursor(false)
    PlayerComps["chattoggle"] = true
end
addEvent("successLogIn",true)
addEventHandler("successLogIn",root,onSuccessLogIn)