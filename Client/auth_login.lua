animateRectangles = {math.random(0,21),math.random(0,21),math.random(0,21),math.random(0,21)}
function onClientClickAuth()
    removeEventHandler("onClientRender",root,onClientMove)
    removeEventHandler("onClientClick",root,onClientClick)
    removeEventHandler("onClientRender",root,dxDrawMainMenu)
    animateBtn(Buttons.login,screenH,50)
    addEventHandler("onClientRender",root,dxDrawAuthMenu)
    addEventHandler("onClientRender",root,onClientMoveLogin)
    logEdit  =  dgsCreateEdit(screenW * 0.11,screenH * 0.14,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))
    passEdit = dgsCreateEdit(screenW * 0.11,screenH * 0.32,screenW * 0.3 - 42,screenH * 0.04,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0,0,0,0))

    ceraReg = dgsCreateFont("Fonts/CeraPro-Regular.ttf",15,false,"antialiased")
    dgsSetFont(logEdit,ceraReg)
    dgsSetFont(passEdit,ceraReg)
    dgsEditSetMasked(passEdit,true)

    edits = {
        login = {
            color = white,
            bgcolor = tocolor(0,0,0,0),
            textcolor = white,
            success = nil
        },
        pass = {
            color = white,
            bgcolor = tocolor(0,0,0,0),
            textcolor = white,
            success = nil
        }
    }
end

function changeWindow()
    rectangleWidth = 0
    local startTime = getTickCount()
end

function dxDrawAuthMenu()
    if not(fontawesome) then
        fontawesome = getFont("Fonts/fontawesome.ttf",15)
    end
    if not(bebasreg) then
        bebasreg = getFont("Fonts/BebasNeue Regular.otf",20)
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
    for k,pos in pairs(animateRectangles) do
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
    dxDrawRectangle(0,Buttons.login.y,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,175))
    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/auth-btn.png")

    dxDrawText("НИКНЕЙМ",screenW * 0.1,screenH * 0.11,screenW * 0.1,screenH * 0.12,edits.login.textcolor,1,bebasreg)
    dxDrawText("ПАРОЛЬ",screenW * 0.1,screenH * 0.29,screenW * 0.1,screenH * 0.12,edits.pass.textcolor,1,bebasreg)


    dxDrawText("",screenW * 0.1,screenH * 0.15,screenW * 0.1,screenH * 0.14,edits.login.color,1,fontawesome)
    dxDrawText("",screenW * 0.1,screenH * 0.33,screenW * 0.1,screenH * 0.14,edits.pass.color,1,fontawesome)

    dxDrawRectangle(screenW * 0.1,screenH * 0.18,screenW * 0.3,2,edits.login.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.14,screenW * 0.3,screenH * 0.04,edits.login.bgcolor)

    dxDrawRectangle(screenW * 0.1,screenH * 0.36,screenW * 0.3,2,edits.pass.color)
    dxDrawRectangle(screenW * 0.1,screenH * 0.32,screenW * 0.3,screenH * 0.04,edits.pass.bgcolor)

end

function onClientMoveLogin()
    if Buttons.login.y == screenH * 0.5 then
        if isMouseInPosition(0,screenH * 0.5,screenW * 0.5,screenH * 0.5) then
            animateBtn(Buttons.login,screenH * 0.5)
        else   
            if Buttons.login.loginY ~= screenH then
                animateBtn(Buttons.login,screenH)
            end
        end
    end
end


function onAcceptEdits()
    local login = dgsGetText(logEdit)
    local pass = dgsGetText(passEdit)
    if string.len(login) >= 6 then
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
end
addEventHandler("onDgsEditAccepted",root,onAcceptEdits)