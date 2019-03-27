
function onClientClickRegister()
    removeEventHandler("onClientRender",root,onClientMove)
    removeEventHandler("onClientClick",root,onClientClick)
    removeEventHandler("onClientRender",root,dxDrawMainMenu)

    addEventHandler("onClientRender",root,dxDrawRegMenu)
    addEventHandler("onDgsEditAccepted",root,onAcceptRegEdits)
    addEventHandler("onClientClick",root,onClientClickRegBtn)

    animateBtn(Buttons.login,screenH,2)

    logEdit  =  dgsCreateEdit(screenW * 0.11,screenH * 0.64,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    emailEdit = dgsCreateEdit(screenW * 0.11,screenH * 0.74,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    passEdit = dgsCreateEdit(screenW * 0.11,screenH * 0.84,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    if not(ceraReg) then
        ceraReg = dgsCreateFont("Fonts/CeraPro-Regular.ttf",15,false,"antialiased")
        dxCeraReg = dxCreateFont("Fonts/CeraPro-Regular.ttf",13,false,"antialiased")
    end
    dgsSetFont(logEdit,ceraReg)
    dgsSetFont(emailEdit,ceraReg)
    dgsSetFont(passEdit,ceraReg)
    dgsEditSetMasked(passEdit,true) 
    animateRectangles[1] = screenH * 0.5
    animateRectangles[2] = screenH * 0.5
    yPosition = -(screenH * 0.5)
    regRt = dxCreateRenderTarget(screenW * 0.5,screenH,true)
end

function dxDrawRegMenu()
    if not(fontawesome) then
        fontawesome = getFont("Fonts/fontawesome.ttf",15,false,"antialiased")
    end
    if not(bebasreg) then
        bebasreg = getFont("Fonts/BebasNeue Regular.otf",20,false,"antialiased")
    end
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/background-login.png")
    dxDrawRectangle(0,0,screenW * 0.5,screenH * 0.5,tocolor(29,29,33,100))
    dxDrawRectangle(0,yPosition,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,175))
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/next-btn.png")

    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/background-reg.png")
    dxDrawRectangle(0,screenH * 0.5,screenW * 0.5,screenH * 0.5, tocolor(29,29,33,155))

    dxDrawText("НИКНЕЙМ",screenW * 0.1,screenH * 0.61,screenW * 0.1,screenH * 0.61,edits.login.textcolor,1,bebasreg)
    dxDrawText("ПОЧТА",screenW * 0.1,screenH * 0.71,screenW * 0.1,screenH * 0.61,edits.email.textcolor,1,bebasreg)
    dxDrawText("ПАРОЛЬ",screenW * 0.1,screenH * 0.81,screenW * 0.1,screenH * 0.61,edits.pass.textcolor,1,bebasreg)

    dxDrawText("",screenW * 0.103,screenH * 0.65,screenW * 0.1,screenH * 0.14,edits.login.color,1,fontawesome)
    dxDrawText("",screenW * 0.103,screenH * 0.75,screenW * 0.1,screenH * 0.14,edits.email.color,1,fontawesome)
    dxDrawText("",screenW * 0.103,screenH * 0.85,screenW * 0.1,screenH * 0.14,edits.pass.color,1,fontawesome)

    if edits.login.success then
        dxDrawText("",screenW * 0.4 - 30,screenH * 0.645,screenW * 0.1,screenH * 0.3,edits.login.color,1,fontawesome)
    elseif edits.login.success == false then
        dxDrawText("",screenW * 0.4 - 30,screenH * 0.645,screenW * 0.1,screenH * 0.3,edits.login.color,1,fontawesome)
    end
    if edits.email.success then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.745,screenW * 0.1,screenH * 0.325,edits.email.color,1,fontawesome)
    elseif edits.email.success == false then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.745,screenW * 0.1,screenH * 0.325,edits.email.color,1,fontawesome)
    end
    if edits.pass.success then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.845,screenW * 0.1,screenH * 0.325,edits.pass.color,1,fontawesome)
    elseif edits.pass.success == false then
        dxDrawText("",screenW * 0.4 - 32,screenH * 0.845,screenW * 0.1,screenH * 0.325,edits.pass.color,1,fontawesome)
    end

    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.01,screenH * 0.08,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.6,screenH * 0.1,screenH * 0.08,screenH * 0.01,SERVERCOLORS.GENERAL)

    dxDrawRectangle(screenW * 0.9,screenH * 0.82,screenH * 0.01,screenH * 0.08,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.855,screenH * 0.89,screenH * 0.08,screenH * 0.01,SERVERCOLORS.GENERAL)

    dxDrawLine(screenW * 0.05,screenH * 0.5,screenW * 0.05,screenH,tocolor(255,255,255,50))
    dxDrawLine(screenW * 0.45,screenH * 0.5,screenW * 0.45,screenH,tocolor(255,255,255,50))
    dxDrawLine(0,screenH * 0.55,screenW * 0.5,screenH * 0.55,tocolor(255,255,255,50))
    dxDrawLine(0,screenH * 0.95,screenW * 0.5,screenH * 0.95,tocolor(255,255,255,50))

    dxSetRenderTarget(regRt,true)
    dxDrawRectangle(screenW * 0.05 - 1,animateRectangles[1],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.45 - 1,animateRectangles[2],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[3],screenH * 0.55 - 1,10,3,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[4],screenH * 0.95 - 1,10,3,SERVERCOLORS.GENERAL)

    dxDrawRectangle(screenW * 0.1,screenH * 0.68,screenW * 0.3,2,edits.login.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.64,screenW * 0.3,screenH * 0.04,edits.login.bgcolor)

    dxDrawRectangle(screenW * 0.1,screenH * 0.88,screenW * 0.3,2,edits.pass.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.84,screenW * 0.3,screenH * 0.04,edits.pass.bgcolor)

    dxDrawRectangle(screenW * 0.1,screenH * 0.78,screenW * 0.3,2,edits.email.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.74,screenW * 0.3,screenH * 0.04,edits.email.bgcolor)
    dxSetRenderTarget()

    for k,pos in ipairs(animateRectangles) do
        if k <= 2 then
            if animateRectangles[k] < screenH then
                animateRectangles[k] = animateRectangles[k]+0.3
            else
                animateRectangles[k] = screenH * 0.5
            end
        else
            if animateRectangles[k] < screenW * 0.5 - 6 then
                animateRectangles[k] = animateRectangles[k]+0.3
            else
                animateRectangles[k] = - 10
            end
        end
    end
    dxDrawImage(0,0,screenW * 0.5,screenH,regRt)
end

function animReg(y,duration) 
    local duration = duration or 1000
    local startTimer = getTickCount()
    local func
    func = function()
        local now = getTickCount()
        local elapsedTime = now - startTimer
        local duration = duration 
        local progress = elapsedTime / duration
        if yPosition ~= y then
            yPosition = interpolateBetween(yPosition,0,0,y,0,0,progress,"Linear")
        else
            removeEventHandler("onClientRender",root,func)
            animList[func] = nil
        end
    end
    animList[func] = true
    addEventHandler("onClientRender",root,func)
end

function onClientClickRegBtn()
    if isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5) then
        onAcceptRegEdits()
    end
end

function onAcceptRegEdits()
    local login = dgsGetText(logEdit)
    local email = dgsGetText(emailEdit)
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
    if string.find(email,"^[%w.]+@%w+%.%w+$") then
        edits.email.color = SERVERCOLORS.GENERAL
        edits.email.bgcolor = tocolor(255,106,19,51)
        edits.email.success = true
        edits.email.textcolor = tocolor(255,255,255)
    else
        edits.email.color = SERVERCOLORS.RED
        edits.email.bgcolor = tocolor(236,32,32,51)
        edits.email.success = false
        edits.email.textcolor = SERVERCOLORS.RED
    end
    dgsSetProperty(emailEdit,"textColor",edits.email.textcolor)
    if edits.login.success and edits.email.success and edits.pass.success then
        triggerServerEvent("onPlayerStartSignUp",localPlayer,login,pass,email)
    end
end

function onSuccessEdits()
    animateChange()
    selectedMenu = "createcharacter"
    setTimer(function()
        destroyElement(logEdit)
        destroyElement(emailEdit)
        destroyElement(passEdit)
    end,50,1)
    
    removeEventHandler("onClientRender",root,dxDrawRegMenu)
    
    removeEventHandler("onDgsEditAccepted",root,onAcceptRegEdits)
    removeEventHandler("onClientClick",root,onClientClickRegBtn)
    removeEventHandler("onClientRender",root,movePlayerCamera)
    removeEventHandler("onClientKey",root,onClientKeyInMenu)

    yPosition = -screenH * 0.5
    addEventHandler("onClientRender",root,onButtonCharacterHover)
    addEventHandler("onClientRender",root,dxDrawCharacterMenu)
    addEventHandler("onClientClick",root,onClickToAngle)
    addEventHandler("onClientKey",root,onPlayerScroll)

    personAge = 21
    personSkins = {
        [1] = {1,2,3},
        [2] = {4,5,6},
        [3] = {7,8,9}
    }
    personSelectedSkin = 1
    personSelectedRace = 1
    ped = createPed(90,0,0,5)
    setElementModel(ped,personSkins[personSelectedRace][personSelectedSkin])
    setCameraMatrix(0,-4,5,0,0,5)
    setCameraTarget(ped)
end
addEvent("onSuccessEdits",true)
addEventHandler("onSuccessEdits",root,onSuccessEdits)

function onErrorEdits()
    edits.login.color = SERVERCOLORS.RED
    edits.login.bgcolor = tocolor(236,32,32,51)
    edits.login.success = false
    edits.login.textcolor = SERVERCOLORS.RED
    edits.email.color = SERVERCOLORS.RED
    edits.email.bgcolor = tocolor(236,32,32,51)
    edits.email.success = false
    edits.email.textcolor = SERVERCOLORS.RED
end
addEvent("onErrorEdits",true)
addEventHandler("onErrorEdits",root,onErrorEdits)